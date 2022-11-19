import interfascia.*;

import org.alicebot.ab.Bot;
import org.alicebot.ab.Chat;
import org.alicebot.ab.History;
import org.alicebot.ab.MagicBooleans;
import org.alicebot.ab.MagicStrings;
import org.alicebot.ab.utils.IOUtils;

import java.util.Map;
import java.util.List;

// Uset interface elements
GUIController controller;
IFTextField userInput;
PFont poppins;

// Chatbot elements
Bot botter;
Chat chatSession;
Conversation conversation;
float scrollValue;

void setup() {
    size(500, 800);
    scrollValue = 0.0;
    noStroke();
    controller = new GUIController(this);
    userInput = new IFTextField("User Input", 0, height - 30, width);
    
    controller.add(userInput);
    userInput.addActionListener(this);
    
    poppins = createFont("Poppins-Regular.ttf", 14);
    textFont(poppins);
    
    
    conversation = new Conversation(); //iug
    botter = new Bot("super", dataPath(""));
    chatSession = new Chat(botter);
    String welcome = chatSession.multisentenceRespond("help");
    conversation.add(new ChatMessage(welcome,SenderType.BOT));
}


void draw() {
    background(#2E282A);
    conversation.display();
}


void sendToBot(String message) {
    String response = chatSession.multisentenceRespond(message);
    
    conversation
   .add(new ChatMessage(message,SenderType.HUMAN))
       .add(new ChatMessage(response,SenderType.BOT));
}


void actionPerformed(GUIEvent element) {
    if (element.getMessage().equals("Completed")) {
        String userMessage = userInput.getValue();
        userInput.setValue("");
        sendToBot(userMessage);
    }
}


void mouseWheel(MouseEvent event) {
    float e = event.getCount();
    scrollValue -= e * 20;
    scrollValue = min(0,scrollValue);
}


class Conversation {
    ArrayList<ChatMessage> conversation;
    
    int messageSpacing;
    int padding;
    
    Conversation() {
        conversation = new ArrayList<>();
        messageSpacing = 20;
        padding = 5;
    }
    
    
    public Conversation add(ChatMessage message) {
        conversation.add(message);
        return this;
    }
    
    public void display() {
        float offset = scrollValue + 20;
        int lineCount = 0;
        int messageHeight = 0;
        
        float x1 = 0, x2 = 0, y1 = 0, y2 = 0;
        for (ChatMessage message : conversation) {
            lineCount = 0;
            //lineCount = message.message.split("\n", -1).length + 1;
            for (String line : message.message.split("\n", -1)){
                lineCount += ceil(textWidth(line)/width);
            }


            messageHeight = 20 * (lineCount+1);
            if (message.senderType == SenderType.HUMAN) {
                fill(#169F9C);
                x1 = 0;
                y1 = offset;
                x2 = min(textWidth(message.message) + padding,width - 10 - padding * 2);
                y2 = messageHeight;
                
            }
            if (message.senderType == SenderType.BOT) {
                fill(#cd5334);
                x1 = max(10,width - textWidth(message.message) - 10 - padding * 2);
                y1 = offset;
                x2 = width;
                y2 = messageHeight;
                
            }
            rect(x1 - padding,y1 - padding,x2 + padding * 2,y2 + padding,10,10,10,10);
            fill(#ffffff);
            text(message.message,x1 + padding,y1 + padding,x2,y2);
            offset += messageHeight + messageSpacing;
        }
    }
    
}

class ChatMessage {
    String message;
    SenderType senderType;
    ChatMessage(String message,SenderType senderType) {
        this.message = message;
        this.senderType = senderType;
    }
}

enum SenderType{
    HUMAN,
    BOT
}