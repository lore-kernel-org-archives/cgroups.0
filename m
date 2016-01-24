From: Dmitri Seletski <drjoms-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: gamer and memory bandwith control
Date: Sun, 24 Jan 2016 19:55:38 +0000
Message-ID: <20160124195538.52826080@myPC>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-transfer-encoding;
        bh=Qii2yObSSgfz0gWBY49FXKn4ypbGWEb6zhbjpP/TH38=;
        b=noTIfKRgT+BG7R+99BJudJCyzS0AK73kwjc8ognq8AKJDHVE7LaeKbYCCG/BmsrOGu
         1ha+16uOb43ZMzFmqKgl6bEEY95QA/k7po/Gz7IeNG7KwyAnaOmj3vZ+7GzvYrKAn7d3
         1E9fJyvcpgIg0PyyK5lK4h47wZJFOTye/TGj04phu8HPBrhady08d26q/MdTRJXWBk1L
         i/3AO4bB5fjjDxQL5/12Z5RE0MCOJshjiZ98cNCCGNF7ElMIdw0//+CRlYshcC3Wuk/r
         MXzxG2nCye3kPliQUTVTX9lLfworjPTVxk7qWu7P6P33+hk+iXF1CSwUHCv0zus+yRuM
         7JZg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello.

I don't usually start threads on major forum lists like this one.
Pardon me if I do something silly or take your valuable time.(i do
consider it to be valuable)

I am gamer and I was looking at opportunities to tweak performance
while I do CPU extensive tasks while playing games.

My distro is Gentoo.
When I install anything - it's compiled from source.
My current compiler settings are '-j 20', since I have 8 core AMD cpu
with 32 gigs of ram.. I tried to limit CPU usage so games that run in
parallel don't have Frames Per Second drops - it didn't help.

On Gentoo forum one of old guys suggested that I should limit memory
bandwith from being  overused by compilation process. He suggested I
look into cgroups.

I looked into it, but I don't see anything specific to limit memory
bandwidth and some other settings available there, don't seem like
something that would help me with memory bottleneck, or would it?

Any suggestions? Any suggestions outside of cgroups?

Any reply is appreciated and will be made public to a few Linux gamer
web sites.(I believe in sharing) YES, we do have those sites now! We
even have games!

Thank you in advance.
Dmitri
