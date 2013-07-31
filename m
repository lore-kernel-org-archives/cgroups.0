From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH 0/4] memcg: fix memcg resource limit overflow issues
Date: Wed, 31 Jul 2013 17:39:43 +0800
Message-ID: <CAFj3OHUEVM+BtoYS8wbXRU42Q8_=1X5qaQm7QY8oBc=ONAdfOA@mail.gmail.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com>
	<CAFj3OHX4WLaecyE_zFbnFKs9wrCWTq2eDAUDMxqPg8=TYt18gg@mail.gmail.com>
	<51F8D016.4090009@huawei.com>
	<51F8D0E1.4010007@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=u9T59nlt1wP3W9T1xVALm7MWeDoCpw+EntsQS2fITR0=;
        b=Lgu+MsZw5QFmzDstHis7hIYFZA/rFLy+Tc6Rku2ojNjBdhzYnW0Salp0fsukBgk9HA
         zI6KMOJXIm9Si/DJfpdso5lvh0rLi1qr6RHc3l2tzDRm3JxcmxWVgFqoqGZ5ktjY8pUU
         IvXUjErLCfR22yOLmv3zl/xr225ETTYaC9lnVIXRfLU3eQAnHk3NmC+4i/r1OQL6KTfm
         mccShJ/nrhPEhjwQAfWETp6bShwmskMdah/Eo9Btvjyqsz+6onqRy+tsUchCU00EmKA7
         3qmgEf95huNc3ValdIWRquMV9+4RBnPzQYnJ2bp8f0DR27LW7cvjBTFQvLX8gCV5lmwP
         WVOg==
In-Reply-To: <51F8D0E1.4010007@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Qiang Huang <h.huangqiang@huawei.com>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Sha Zhengju <handai.szj@taobao.com>, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Jeff Liu <jeff.liu@oracle.com>

On Wed, Jul 31, 2013 at 4:54 PM, Li Zefan <lizefan@huawei.com> wrote:
> On 2013/7/31 16:51, Qiang Huang wrote:
>> On 2013/7/31 16:23, Sha Zhengju wrote:
>>> Hi list,
>>>
>>> On Wed, Jul 31, 2013 at 3:31 PM, Qiang Huang <h.huangqiang@huawei.com> wrote:
>>>> This issue is first discussed in:
>>>> http://marc.info/?l=linux-mm&m=136574878704295&w=2
>>>>
>>>> Then a second version sent to:
>>>> http://marc.info/?l=linux-mm&m=136776855928310&w=2
>>>>
>>>> We contacted Sha a month ago, she seems have no time to deal with it
>>>> recently, but we quite need this patch. So I modified and resent it.
>>>
>>>
>>> No, I didn't receive any of YOUR message, only a engineer named Libo
>>> Chen from Huawei connected me recently. I don't approve you to resent
>>> them on behalf of me, and just before you send this you even don't
>>> send me a mail. Besides, after a rough look, I do not see any
>>> innovative ideas from yourself but just rework patches from my last
>>> version.
>>> So I'm strong against this patchset.
>>
>> Sorry if this troubles you.
>> Libo Chen is my colleague, we work together, he sent an email to you on
>> 25 June, to ask about this issue, you said you'll resent it soon, but it
>> didn't happen until now :(, and he asked again the other day and you didn't
>> reply. As we really need to fix this problem(and need it in upstream), so
>> I modified it and sent out.
>>
>> I think split patches, rewrite changelogs and tests, they all kind of work
>> right? Of course, if you mind, I can change it, I just need this fix merged
>> to upstream ASAP.
>>
>> So you want me rewrite this patchset and SOB only you or you want resent this
>> by yourself? I'm ok with both :)
>>
>
> No, you can't send out patches without your SOB...but you can add a line
> in the beginning of the email:
>
> From: Sha Zhengju <handai.szj@taobao.com>
>

Cooperation is welcomed and I just hated this kind of behavior. I
don't want to block the community, since they're urgent to the patches
and Michal has already reviewed them just now,  I won't be so caustic
on it. I'm OK of letting the codes in under the rules of community.

-- 
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
