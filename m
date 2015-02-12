From: Greg Thelen <gthelen@google.com>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 18:10:06 -0800
Message-ID: <CAHH2K0agT1X9vZn56O9NFOEyEW65Tgnsrb9S4X6Dn2dtMi-iWg@mail.gmail.com>
References: <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com> <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com> <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com> <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org> <20150211021906.GA21356@htj.duckdns.org>
 <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com> <20150211203359.GF21356@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=lU7jKOz+2GfCtwIZKOszJMNy7kTOwzPIF+eHVC38EE8=;
        b=ap5S7tChf7IqcYa3RsLzVOn81BKiGFIok08UJMqTmlDLXkLEKUgOdwhUKYFZ8iF6ah
         nZNAy6YqZRjH3iUEO6g6Q97oiSmmLeSa99IRTz26cl4MRMJG50c6oyuDXHYB0Xg21QTd
         2mAZT/X1td+mlthwdIL/hDmcVfLyesusCqcgisKwJF6NESez989cOv/d+DWEr8Wn3u9Y
         0/QwvCiRwybxA9nhG1X6t29NmNaWlG/EFiXpJzM/GyHN4/aSIxyHeNSJlypGzf2a8EeI
         QzIBH4pj+kb848bZRtNuMBq9ZT3rl6rtn5dhw3Z+he9LNuaIGEUgmOSh2//1i8lPFb56
         QRuw==
In-Reply-To: <20150211203359.GF21356@htj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

On Wed, Feb 11, 2015 at 12:33 PM, Tejun Heo <tj@kernel.org> wrote:
[...]
>> page count to throttle based on blkcg's bandwidth.  Note: memcg
>> doesn't yet have dirty page counts, but several of us have made
>> attempts at adding the counters.  And it shouldn't be hard to get them
>> merged.
>
> Can you please post those?

Will do.  Rebasing and testing needed, so it won't be today.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
