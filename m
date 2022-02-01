From: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: Re: LTP test suite triggers LOCKDEP_CIRCULAR on linux-next
Date: Tue, 01 Feb 2022 08:57:29 +0100
Message-ID: <87tudjow7q.fsf@oc8242746057.ibm.com>
References: <87mtjzslv7.fsf@oc8242746057.ibm.com>
 <YeI78TMjU12qRmQ8@carbon.dhcp.thefacebook.com>
 <YfgWAuzAo2WDyPH+@carbon.dhcp.thefacebook.com>
 <87r18nj01l.fsf@oc8242746057.ibm.com>
 <Yfgaf885yDFPtjJH@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : cc :
 subject : in-reply-to : in-reply-to : references : date : message-id :
 mime-version : content-type; s=pp1;
 bh=uuxhueiyYauBBegXUW2RmKe02lmKTiZq/8hDUJP4EZY=;
 b=sSvPViUMD2obHA44CvZkGPhjj691gKY6i3MGlIHqHDqlCHTh5u1PlPeA1T0cONpKYl/Z
 mHNQNqXMQN43Vk8T0R1J9HApRBfxi6c6U6hGGH6m73TpIDuFe5uPVnkQr/pKTz7sVLKY
 gYPtiSm1cjimhWzEguWSkiVC8zGn4hdu/Ph5GllPbSWABysqXSp7RhpHvXte7HgEKtA9
 em9xATQGNwY1WNpIJEICnsAvdh0yth1KNY08CRPkMw9wg8GDGjRa/DMjCKg8oozfYbOf
 q7BIZyL1iBuCMTlkNhEoymDZEEPzd2Tkvi/dCcQJERdhMdmtcZTt4pMLQJ0R+qTHz/z7 DQ== 
In-Reply-To: <Yfgaf885yDFPtjJH-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Roman,

Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> writes:

> On Mon, Jan 31, 2022 at 06:19:02PM +0100, Alexander Egorenkov wrote:
>> Hi Roman,
>> 
>> 
>> Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> writes:
>> 
>> > On Fri, Jan 14, 2022 at 07:13:53PM -0800, Roman Gushchin wrote:
>> >> On Thu, Jan 13, 2022 at 04:20:44PM +0100, Alexander Egorenkov wrote:
>> >> 
>> >> Hi Alexander!
>> >> 
>> >> Can you, please, check if the following patch is fixing the problem for you?
>> >> 
>> >> Thanks a lot in advance!
>> >
>> > Friendly ping.
>> >
>> > Thanks!
>> 
>> I'm very sorry for late response,
>> we just noticed your mails :(
>> We installed your patch and today's CI run will use it for testing on
>> s390 arch.
>> I will have reports tomorrow.
>> 
>> Thanks for prompt response!
>
> Perfect, thank you so much!

i'm happy to report that the provided patch fixed the message
and our CI tests for s390 cannot reproduce the situation anymore.

Thanks!

Regards
Alex
