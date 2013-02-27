From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Date: Wed, 27 Feb 2013 09:47:37 +0200
Message-ID: <CAOJsxLFzrw0pCzUG7Ru4dB9=aPoNKHiJ_y3bopiFvBhzV9A5Zg@mail.gmail.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
	<alpine.DEB.2.02.1302221034380.7600@gentwo.org>
	<alpine.DEB.2.02.1302221057430.7600@gentwo.org>
	<0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
	<5127A607.3040603@parallels.com>
	<0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=yD8IkM5xY/YN8UwRgSmnsk4j+1g4/Qm48//91K5vdAQ=;
        b=ZjnNiSyA0mg4oyN3Zh1KBeYIDOsEjAKLlfRCzDlMitzGCtTV87SyGaSRKQ/llcRaHw
         8BCs2TxZf0Exo3L8TWfIod5pqnGErPuG+kbAaKAgSx9YQsOhm4tXqJNP3vO+KjhYtdhf
         4WVzEvmiFjnb908UtouGx5JpzqAB2QCfvl0BCzD1h2J2uwpxtQM50nfIkH4959R/66I9
         do71J6TcQpTfv7C+56Z4/mOZvu6msJDmbtLM5tQ/vVss2BEoW6YGNMp+NFNC4hbad8A/
         b0HfXC2miEKdBqmSwBOIE9CW7pfoTQd1zR0Gvr767uI4RikPdxxWje9tasvTVvq3qEtV
         rHuA==
In-Reply-To: <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri, Feb 22, 2013 at 7:23 PM, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, 22 Feb 2013, Glauber Costa wrote:
>
>> On 02/22/2013 09:01 PM, Christoph Lameter wrote:
>> > Argh. This one was the final version:
>> >
>> > https://patchwork.kernel.org/patch/2009521/
>> >
>>
>> It seems it would work. It is all the same to me.
>> Which one do you prefer?
>
> Flushing seems to be simpler and less code.

Well, I completely lost track of what to apply... Can someone please
send me the final version that everybody agrees on with proper ACKs
and other attributions?
