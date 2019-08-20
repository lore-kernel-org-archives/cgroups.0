From: Paolo Valente <paolo.valente@linaro.org>
Subject: Re: [PATCHSET block/for-next] IO cost model based work-conserving
 porportional controller
Date: Tue, 20 Aug 2019 12:48:09 +0200
Message-ID: <5A63F937-F7B5-4D09-9DB4-C73D6F571D50@linaro.org>
References: <20190614015620.1587672-1-tj@kernel.org>
 <20190614175642.GA657710@devbig004.ftw2.facebook.com>
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8YhdYjqe+CTt77YsPRFesv990RDPmX6UdhabR8/j8l8=;
        b=dgG7nSaegDa/f34PzKpV/NDTRDbAf4Tn8ESgBGCCvyBUctxq98sGkgyEW3giHSJqxI
         yUlLAH58TbPebsNICnhxbv2FhjuVdm71H1yyw5DTYaHXUr2mcxTajrDMX8YQgXP6K59l
         KMlqgNId7X/0kUtpLyRyUbCvjdArWdQ99nv9N56pBQaxb3fB9btAbzRfZfUnDKcyc653
         FieTVsewJyyWcgh+hruCD2sviZgKsiiLWf5EamLzSfUSXhw0pHGE0djlhbWl5DfBK/qL
         x+kZDh5BOO4jY2T8+YBs/0azHTKHddDMvZO7kBrbJSv/Sg/eUgpzfCZxDVIdodTyN4C4
         JChA==
In-Reply-To: <20190614175642.GA657710@devbig004.ftw2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, newella@fb.com, clm@fb.com, Josef Bacik <josef@toxicpanda.com>, dennisz@fb.com, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com, yhs@fb.com, bpf@vger.kernel.org



> Il giorno 14 giu 2019, alle ore 19:56, Tejun Heo <tj@kernel.org> ha =
scritto:
>=20
> On Thu, Jun 13, 2019 at 06:56:10PM -0700, Tejun Heo wrote:
> ...
>> The patchset is also available in the following git branch.
>>=20
>> git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git =
review-iow
>=20
> Updated patchset available in the following branch.  Just build fixes
> and cosmetic changes for now.
>=20
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git =
review-iow-v2
>=20

Hi Tejun,
I'm running the kernel in your tree above, in an Ubuntu 18.04.

After unmounting the v1 blkio controller that gets mounted at startup
I have created v2 root as follows

$ mount -t cgroup2 none /cgroup

Then I have:
$ ls /cgroup
cgroup.controllers  cgroup.max.descendants  cgroup.stat             =
cgroup.threads  io.weight.cost_model  system.slice
cgroup.max.depth    cgroup.procs            cgroup.subtree_control  =
init.scope      io.weight.qos         user.slice

But the following command gives no output:
$ cat /cgroup/io.weight.qos=20

And, above all,
$ echo 1 > /cgroup/io.weight.qos=20
bash: echo: write error: Invalid argument

No complain in the kernel log.

What am I doing wrong? How can I make the controller work?

Thanks,
Paolo

> Thanks.
>=20
> --=20
> tejun

