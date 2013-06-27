From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Thu, 27 Jun 2013 11:52:32 -0700
Message-ID: <CAOS58YNSCkS=5xiJZSq+=CFEYUE2kyn5dpbPSCViB4=+hQKx3A@mail.gmail.com>
References: <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
	<CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
	<20130625000118.GT1918@mtj.dyndns.org>
	<CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
	<20130626212047.GB4536@htj.dyndns.org>
	<1372311907.5871.78.camel@marge.simpson.net>
	<20130627132206.GE4003@sergelap>
	<20130627174850.GC5599@mtj.dyndns.org>
	<20130627181457.GB26334@sergelap>
	<20130627184541.GA6400@mtj.dyndns.org>
	<20130627185104.GA2018@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=gLBZvMeE0z9soE0Mx4le+gk0pmpNFK9V8GxI37RS2aI=;
        b=Lnkpz3bCcdWuuyPQep0WzjIFSSQssL+dt9Ps6obKiwLeqxnxbIS3ihmB1BkaiMqBVC
         7QUpBBJkTr/8N5d4Xp2WGcKB08OVioIFOZnJJWCX8CugMgfTRL4uPNkXGz/CwF70UbVI
         EeiWZvQWI8PESrjgoa88IHt9Ql7ng2rzaPLMXWAICDiHPS3IN2a8BSXw1rQimnbl9K7w
         /UbGIvMQYDcgeosi4UP1qnpg1UX/GW9pLokA08xCOX0auGFj1FcEuvnlfeBOu6JsYxds
         3zHBKbI8w2VzBZV/dnqP0+fXJjY7FBk8UBHXf7L5cz/pyCEdutkBo2pYwEKYRbzy43w5
         +G3A==
In-Reply-To: <20130627185104.GA2018@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Thu, Jun 27, 2013 at 11:51 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
>> I think it probably would be better to allow organization and RO
>
> What do you mean by "organization"?  Creating cgroups and moving tasks
> between them, without setting other cgroup values?

Yeap, I also think that's how user sessions are gonna be handled.
We're gonna have limited amount of delegation for organization and
read accesses.

Thanks.

--
tejun
