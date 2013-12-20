From: Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH v14 16/18] vmpressure: in-kernel notifications
Date: Fri, 20 Dec 2013 18:32:41 +0400
Message-ID: <CAA6-i6rqCm44yJjf0dy=L+rYGEH=WUoNzX4+qh5poGgSsA=W-Q@mail.gmail.com>
References: <cover.1387193771.git.vdavydov@parallels.com>
	<abff42910c131a9c94a7518de59b283ee0a2dcd1.1387193771.git.vdavydov@parallels.com>
	<20131220092659.0ed23cf5@redhat.com>
	<CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=zGE8+eT/QHJBYm3HrDG336K5gWnwXTUq5riM9n/ASHo=;
        b=UQTRJ6c5JYV8Mme7tzho2GPtpsay3wqMr/3QUC/s/ZVyVsPDhVAGc22PEfuoed+sBO
         xi7+Jt7iToy8zK9M5esdhTmEyIIOHJibm+NwCf/UQ6Y8GLbTMMo64LoJZn4abHobS3pr
         z5BsD6WJ/wdA66d8wpM8rmovSjmC8m59/Ke+GkdExbkThCAR1tE6mDJe+essDlmi9xFQ
         oplGH8gHe/KYp5292AC5o4HPafUd6fqyS0FeraV4909N60vKVA37NH+9HaeYFHkZbM6Z
         1GYi1wVU7DtLshi2ZpnBBD/mxwWhzWCOE6j/7KAymrWFLsDRz6BMGRQJpdy4kYUMN3HI
         nkAg==
In-Reply-To: <CAA6-i6pDqDemeQ+s4EorOx39qmNAtAfVYfg0Z2wtTEu-S7mY=A@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, dchinner@redhat.com, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Glauber Costa <glommer@openvz.org>, John Stultz <john.stultz@linaro.org>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

One correction:

>>  int vmpressure_register_kernel_event(struct cgroup_subsys_state *css,
>> -                                     void (*fn)(void))
>> +                                    void (*fn)(void *data, int level), void *data)
>>  {
>> -       struct vmpressure *vmpr = css_to_vmpressure(css);
>> +       struct vmpressure *vmpr;
>>         struct vmpressure_event *ev;
>>
>> +       vmpr = css ? css_to_vmpressure(css) : memcg_to_vmpressure(NULL);
>> +

This looks like it could be improved. Better not to have that memcg
specific thing
here.

Other than that it makes sense.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
