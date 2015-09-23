From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH 2/2] ext4: implement cgroup writeback support
Date: Wed, 23 Sep 2015 13:53:37 -0400
Message-ID: <20150923175337.GD25218@ret.masoncoding.com>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
 <1434495193-31182-3-git-send-email-tj@kernel.org>
 <20150722035620.GD2944@thunk.org>
 <1443012552.19983.209.camel@gmail.com>
 <20150923172535.GC25218@ret.masoncoding.com>
 <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=d2WmcuCLRyelnMZTsGowmD/VOt3c1pygqdKNZ5a0kyw=;
 b=YDz0m08xPMCttn6x+QzS11JvbXdNkVCEND2MnS0F2jGS/EFrQ2YF69vtUXq2OOJPyu4c
 g2HjYKDv/zfaVhADdFNHEtdPROcmVuMTf/t4dobuekBxsEec+5Zjy9hMv1PVpZYgSSBR
 cNkomTzLtH0e8WMb5cmK8pnGj4Wn8+lHyuk= 
Content-Disposition: inline
In-Reply-To: <CAF4G-tKEcnVw76-ZU77AjmBDGybLnNEOKjkJtYBN67es0wb30g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-ext4@vger.kernel.org, hannes@cmpxchg.org, axboe@kernel.dk, Tejun Heo <tj@kernel.org>, Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, adilger.kernel@dilger.ca, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Wed, Sep 23, 2015 at 08:41:25PM +0300, Artem Bityutskiy wrote:
>    Hi
> 
>    $ sync
>    $ reboot

If this is case, it should be possible to reproduce with:

cp a bunch of stuff to /ext4
unmount /ext4
mount ext4
compare data

If you're not getting a clean unmount of the test FS during the reboot,
its a different test.  Trying to reproduce here, so far its clean.
Could you please double check for failed unmounts?

Thanks,
Chris
