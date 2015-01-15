From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: Re: [PATCH 3/6] memcg: track shared inodes with dirty pages
Date: Thu, 15 Jan 2015 23:04:49 +0400
Message-ID: <CALYGNiPY2K6F+OFoCV5XShrXaQOiyGXreR=4TC=Mp7axTiF0YQ@mail.gmail.com>
References: <20150115180242.10450.92.stgit@buzz>
	<20150115184914.10450.51964.stgit@buzz>
	<20150115185543.GA28195@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=teHf6kiQRXoAAv8ZDwb+lv9EzZBrfIjw4DIGxhNpAw4=;
        b=sTM7ZI10mPu5rrABCfSzYssYsuzDEkojYyJ710ESHRFCzp1eyyNrdNNFv/o5FDXfyq
         nBLwPcEa4HPLHddne/egOB7JN1LD/OMR14JQP2Gpa3Wjk10qB3hhR98MnH1lj5IiFawH
         xSGDVQPjFLkzijZjbCd65swfdFEWlSoMr7aYkjyOJ62/CZ1SDs4JEHO6iviysuFOmsNz
         t/orrbNCPp9n1dF53GKr15JpKpo1g0hYGO0k2E4zWl7rVJ5xkraCWHV8+sTn4BK9DgYh
         lea7ksm94H847qduJ+IolNSXFFe5nu06Xl1dX8QG28M34dtYjJx+NfpNxhX+uXK1FdNT
         N6nQ==
In-Reply-To: <20150115185543.GA28195@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Konstantin Khebnikov <khlebnikov@yandex-team.ru>, "linux-mm@kvack.org" <linux-mm@kvack.org>, cgroups@vger.kernel.org, Roman Gushchin <klamm@yandex-team.ru>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Jan 15, 2015 at 9:55 PM, Tejun Heo <tj@kernel.org> wrote:
> On Thu, Jan 15, 2015 at 09:49:14PM +0300, Konstantin Khebnikov wrote:
>> From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>>
>> Inode is owned only by one memory cgroup, but if it's shared it might
>> contain pages from multiple cgroups. This patch detects this situation
>> in memory reclaiemer and marks dirty inode with flag I_DIRTY_SHARED
>> which is cleared only when data is completely written. Memcg writeback
>> always writes such inodes.
>>
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
>
> This conflicts with the writeback cgroup support patchset which will
> solve the writeback and memcg problem a lot more comprehensively.
>
>  http://lkml.kernel.org/g/1420579582-8516-1-git-send-email-tj@kernel.org
>
> Thanks.

I know. Absolutely accurate per-page solution looks too complicated for me.
Is there any real demand for accurate handling dirty set in shared inodes?
Doing whole accounting in per-inode basis makes life so much easier.

>
> --
> tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
