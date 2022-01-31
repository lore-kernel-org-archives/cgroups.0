From: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: LTP test suite triggers LOCKDEP_CIRCULAR on linux-next
Date: Mon, 31 Jan 2022 18:19:02 +0100
Message-ID: <87r18nj01l.fsf@oc8242746057.ibm.com>
References: <87mtjzslv7.fsf@oc8242746057.ibm.com>
 <YeI78TMjU12qRmQ8@carbon.dhcp.thefacebook.com>
 <YfgWAuzAo2WDyPH+@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : references : date : message-id :
 mime-version : content-type; s=pp1;
 bh=poY0kfQh15XSlaopeCLHDnvfnTwXN0R1WdEoLg1//UI=;
 b=totHUAPubofj9Gd2V6jJYRo46ExN8ckmGGxwgMrWTUfvO6vK9uRGr17d+0UgburzWOiM
 G+yszAeaO3Yx7rCo8NYlEVhgL90n+ufMSkKiFC8F6imMAXe9gXgtkpf3AyPuiN3jUvUh
 9CPIsjLibWGLwGyStPcDE9WS9U8yQWPOC6Icu6YTJP9+HjBNXYbMhazFJNuWvz+y48kS
 Qr/9Iz06IIcALxFGM3H4tjmubNTLbgoJT9//JuUu8+E0SodB2Em8/5EaPee7fTJFuyEZ
 Uk4mWLp9l9lrQ+pJfEc1WVzz+xIX2Nu5L9EmexLgvv8bgJYfVJUgBOsG6+7bBqUjGgYd CQ== 
In-Reply-To: <YfgWAuzAo2WDyPH+-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Roman,


Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> writes:

> On Fri, Jan 14, 2022 at 07:13:53PM -0800, Roman Gushchin wrote:
>> On Thu, Jan 13, 2022 at 04:20:44PM +0100, Alexander Egorenkov wrote:
>> 
>> Hi Alexander!
>> 
>> Can you, please, check if the following patch is fixing the problem for you?
>> 
>> Thanks a lot in advance!
>
> Friendly ping.
>
> Thanks!

I'm very sorry for late response,
we just noticed your mails :(
We installed your patch and today's CI run will use it for testing on
s390 arch.
I will have reports tomorrow.

Thanks for prompt response!

Regards
Alex
