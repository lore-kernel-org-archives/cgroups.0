From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 8/9] devcg: refactor dev_exception_clean()
Date: Wed, 30 Jan 2013 12:50:38 -0800
Message-ID: <CAOS58YOHkK9xTBPFAXKksrwP7ZxQc_WuGOp39D94Z1pBsFHfjw@mail.gmail.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
	<20130130171102.253395279@napanee.usersys.redhat.com>
	<20130130204730.GF8507@mail.hallyn.com>
	<20130130204917.GL17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=a+XMMOe8A5GpT1eNDSD0kvthj86334Dp6/4XPO6iLQ8=;
        b=na6AppShviEP7CWyBGoa/xnaRXwfmfjVvNZ1nXm+1ICv6BD/xo/wREa2MevrAkcAFH
         KaikF1m68SdXB/ZxW6vwArIxknwGDpIzBj7SR8gTM7T3PfCFHhAwO8gr4pF+QtLfE8T/
         z44jP3S729Kf2hpKgjGA9HxIB2fDQ42Uu637fN7xOWwEYKdxN3PTCzpW/tB2twCmqc2M
         geALdAyvfEHTsCY5+GnrKf2lPHVJO2mT6jsEwZm7c0RuRk3F1naoL7zXIZQRouvW7efj
         /0DFewnabDyg3i/VKClDymWNmFcMg7Pbmw22Fjl7wwHo20T7up3pzg38FdaU4eecWoR0
         9/gQ==
In-Reply-To: <20130130204917.GL17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hello,

On Wed, Jan 30, 2013 at 12:49 PM, Aristeu Rozanski > that's not
intentional. thanks for catching this
>
> Tejun, you want me to resubmit the whole series or just the next patch
> (where I was supposed to move that chunk)?

If it doesn't affect the next patch, just posting an updated version
of this patch should be enough, I think. Which tree are these patches
planned to go through?

Thanks.

-- 
tejun
