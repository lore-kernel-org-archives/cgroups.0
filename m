From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Fri, 6 Sep 2019 07:58:26 -0700
Message-ID: <20190906145826.GL2263813@devbig004.ftw2.facebook.com>
References: <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
 <B5E431F7-549D-4FC4-A098-D074DF9586A1@linaro.org>
 <20190820151903.GH2263813@devbig004.ftw2.facebook.com>
 <9EB760CE-0028-4766-AE9D-6E90028D8579@linaro.org>
 <20190831065358.GF2263813@devbig004.ftw2.facebook.com>
 <88C7DC68-680E-49BB-9699-509B9B0B12A0@linaro.org>
 <20190902155652.GH2263813@devbig004.ftw2.facebook.com>
 <D9F6BC6D-FEB3-40CA-A33C-F501AE4434F0@linaro.org>
 <20190905165540.GJ2263813@devbig004.ftw2.facebook.com>
 <EFFA2298-8614-4AFC-9208-B36976F6548C@linaro.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LOL4RkhxwNmxVBDlkkOKh5q7eIdq3MEVHDS6KxIm1I4=;
        b=MOXP8ySNFPJpMxFpoTNloLC7w8Wh/zABeSUGLmy9GcZZLTPwTWbLNAiqmpDc3ec4/o
         fd/SQEbUNPqNvtpl1/z5Lvnd779JkYSuyqQbJvM8lCbSRUV/hrvYwZxSgL1rKwz0us/i
         ZREmz6vxrZfPNGqJkZmhWJzITJzzyL2gIw8RxEgkUTgtbxCjFWnGsP1l5JXqBN4ds0LM
         SVyRMrlR29TEH85320jHVL5TDIO8nn5KCyJ9cdcTr0DMf2el5OoMqyCl+KPnXNdr78gM
         NnqSEpEKFjrjmUF5jre4PNzvz5/0G04w9u5myf8I6/pAcoyhos2ouAn+mFiJ6I12Kg6r
         75JQ==
Content-Disposition: inline
In-Reply-To: <EFFA2298-8614-4AFC-9208-B36976F6548C@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Valente <paolo.valente@linaro.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org

Hello, Paolo.

On Fri, Sep 06, 2019 at 11:07:17AM +0200, Paolo Valente wrote:
> email.  As for the filesystem, I'm interested in ext4, because it is
> the most widely used file system, and, with some workloads, it makes

Ext4 can't do writeback control as it currently stands.  It creates
hard ordering across data writes from different cgroups.  No matter
what mechanism you use for IO control, it is broken.  I'm sure it's
fixable but does need some work.

That said, read-only tests like you're doing should work fine on ext4
too but the last time I tested io control on ext4 is more than a year
ago so something might have changed in the meantime.

Just to rule out this isn't what you're hitting.  Can you please run
your test on btrfs with the following patchset applied?

 http://lkml.kernel.org/r/20190710192818.1069475-1-tj@kernel.org

And as I wrote in the previous reply, I did run your benchmark on one
of the test machines and it did work fine.

Thanks.

-- 
tejun
