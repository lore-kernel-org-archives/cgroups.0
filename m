From: Alexandre LAURENT <pro.laurent.alexandre-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Fwd: blkio cgroups and precise io out control
Date: Fri, 7 Mar 2014 16:06:47 +0100
Message-ID: <CAN05tNWKP-_s1SMf4AudtcpLrs92UaO=ssfQNStEMtMdQZ42sw@mail.gmail.com>
References: <CAN05tNWLRLt1Kr6vY9Gx8iTK38hfUBw5PKJH9SttuVHQ8Smfrg@mail.gmail.com>
	<CAN05tNVaXy+1dGvPu_g94mPJ-hrGXtdVBEGU2hq0YnYE+Zq5sw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        bh=Ud+YMU/sU59BQLm+ghsovhJRFjSHCNa9e1e16F+jyIc=;
        b=jNJMWe6e2C/LZKBzaTzhtNq3za9ksi2vqJpwBtcUOXKSdhc8mA8bVWhfmNdXIZ1Q5x
         Gnuv0JBFK4lcj8AvEzNkx6xA0fDeD7TOcoX1IuIKGyHu2YGbd+CfEFxPxAewb1SEsgZ4
         +FpYnU85aiLO9G5VVqHl06juHaU34n6dxM/SXB2daDLk4QXyVWHXaDHdsEGmHu9ircvo
         PuymrdT3jhTzhA5oQiA83B72bTSuUQIi0b5jc8TfIQm+A6OD648mcAonLW//vVRWjxHU
         ez1EMj78eGhYn3JHOppAvFsPFFD1QTEF0HUDGVRqMpu5UXtkNfvpteMkLg94HkwoY+No
         6OWA==
In-Reply-To: <CAN05tNVaXy+1dGvPu_g94mPJ-hrGXtdVBEGU2hq0YnYE+Zq5sw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

I'm interested in controlling the I/O operations on my system and
prioritizing writes of various programs. I'm then using the blkio
throttling but, as stated in the documentation it does not perform
well with buffered writes. However, I would be *very* interested in
throttling buffered writes. I've seen Fengguang Wu patch:
https://lkml.org/lkml/2012/4/23/70 but it does not seem to be included
in current mainstream kernels. What would be my best option to achieve
throttling on buffered writes? (experimental code is acceptable) Is
there any experimental kernel patch or branch that I could use?

Thanks,

Alexandre Laurent
