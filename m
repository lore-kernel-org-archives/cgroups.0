From: Zhu Yanhai <zhu.yanhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: What's the progress of per cgroup background reclaim?
Date: Mon, 19 Mar 2012 16:09:34 +0800
Message-ID: <CAC8teKWuhecCzE7CB21eVz_CRsdYRpmKEcTJ4yTGUk2bMo0pmA@mail.gmail.com>
References: <CAC8teKW9Yry114+B06XiFbOtamwS6fNLzrKYo8PZazjEzMCiNQ@mail.gmail.com>
 <CALWz4iyqyQD3g27J=wLvQ=WN0enXLB3rmHDAb51UJaLPJDz5BA@mail.gmail.com>
 <CAC8teKUrJ_ufkhtVAnsv-gzHfYmp8agY_bncOYS7mEdiqD+YZA@mail.gmail.com> <CALWz4iwO+eGFW23qVwjy=MKufRtiVck08pJphSij226pjTQiBw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=HXEy/gDMQ6FNud/n7zQRYOASAykX4hwf0D6H+uog3lQ=;
        b=BhOnLpZgIBucjQJgWYg5VFGxvdlUq4c//vQhwhgxbeA/Ozn+KbRLViG5cQQr9jfPV7
         O7l2lt7LNtvWARZpOtqbLU1reJPDZ0CEZxNJiyMuS55WVzhmFFoesOBgouj8NCRY3jnt
         QJUNuozqWc7NOce+7nRrU7swtMO8GSXhl8NUAHT5UhkRvlnzrkFqT6z2ZwE6fiLKFMq1
         ZmqjU9XjkS5GvioSstey02gpRaeGuCkRNtquZSVk+5KQnGtM0dPxMKPVkRjweDYJBloy
         4RndjkQV9BkMBW98YR+Ru4WEO9W7OuSCruWiqr9xthpAN5oDHJnOLbj6X+fbNNSpyOPo
         Xmow==
In-Reply-To: <CALWz4iwO+eGFW23qVwjy=MKufRtiVck08pJphSij226pjTQiBw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

Hi,

2012/3/16 Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>:
>
> Thank you for the information.
>
> Sounds like that is exactly what the per-memcg kswapd was designed
> for. Two things I am interested to looking into now:
>
> 1. why the per-memcg direct reclaim introduce such noticeable latency
> spike, what workload that can reproduce that?
Sure, I will look into this this week.
>
> 2. we can quickly patch the last version of per-memcg kswapd (V6) on
> your environment and see what difference it makes. Maybe I can help on
> that.
Thanks a lot.
>
> Thanks
>
> --Ying
>
>> --
>> Thanks,
>> Zhu Yanhai
>>
>>> --Ying
>>>
>>>>
>>>> Thanks,
>>>> Zhu Yanhai
