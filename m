From: Roman Gushchin <guro@fb.com>
Subject: Re: Some questions about cgroup aware OOM killer.
Date: Thu, 19 Apr 2018 11:43:42 +0100
Message-ID: <20180419104336.GA20675@castle.DHCP.thefacebook.com>
References: <1524122224-26670-1-git-send-email-ufo19890607@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=facebook;
 bh=rut6R1O0dnJEpPKj8+6EDvs4bYkM77jWnzli+Vtn+Ko=;
 b=Pn24MNF1qFElhjjc2fAEznjgR6LIqiTUPak7dsR8rjc7JRJIlkk9WVm56sOCoJP6WCTr
 mEHy28pm06Gf5mgXrcMr4ArYLhkRJ74zagacIGUdbHOTWUijFcR2VvSy0/mrQR2rg8+O
 UlbxgbkMN0rMx3J2Ufe7uXtmeTE8ygD5jQk= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=rut6R1O0dnJEpPKj8+6EDvs4bYkM77jWnzli+Vtn+Ko=;
 b=A0pWOmg44Ju+5eS2JlbAxaHT27gV/4/PVljHF73Jdekh8lqAB/BKwT3sxEgsYvhS1+UCxSKsN3RAGgKfAVBEeYsh2kWSaZNucz2C3YPswDSf9DSab/lTRQZ+jsVvCoDdtl2XU6DoW3e1BQjBWDUOTkt3VZKOkGmsCCye34Ral4M=
Content-Disposition: inline
In-Reply-To: <1524122224-26670-1-git-send-email-ufo19890607@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: ufo19890607 <ufo19890607@gmail.com>
Cc: mhocko@suse.com, vdavydov.dev@gmail.com, penguin-kernel@i-love.sakura.ne.jp, rientjes@google.com, akpm@linux-foundation.org, tj@kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, yuzhoujian <yuzhoujian@didichuxing.com>

Hi!

Please, pull the whole patchset from the next tree:
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

$ git log next/master --oneline --author=guro@fb.com
1fecc970ac9e cgroup: list groupoom in cgroup features
dff73d397f7f mm-oom-docs-describe-the-cgroup-aware-oom-killer-fix
7cf83086511a mm, oom, docs: describe the cgroup-aware OOM killer
e2194b2869f1 mm, oom: add cgroup v2 mount option for cgroup-aware OOM killer
338fbcc52518 mm, oom: return error on access to memory.oom_group if groupoom is disabled
96fb32250ded mm, oom: introduce memory.oom_group
ed5f99985bf8 mm, oom: cgroup-aware OOM killer
e33eba2c3273 mm: implement mem_cgroup_scan_tasks() for the root memory cgroup
9bd3a4c529d4 mm, oom: refactor oom_kill_process()

Thanks!

On Thu, Apr 19, 2018 at 08:17:04AM +0100, ufo19890607 wrote:
> From: yuzhoujian <yuzhoujian@didichuxing.com>
> 
> Hi Roman
> I've read your patchset about cgroup aware OOM killer, and try
> to merge your patchset to the upstream kernel(v4.17-rc1). But
> I found some functions which in your patch([PATCH v13 3/7] 
> mm, oom: cgroup-aware OOM killer) does not exist in the upstream
> kernel. Which version of the kernel do you patch on? And, do you
> have the latest patchset?
> 
> The faults in PATCH v13 3/7:
> 1. mm/oom_kill.o: In function `out_of_memory':
>    /linux/mm/oom_kill.c:1125: undefined reference to `alloc_pages_before_oomkill'
> 2. mm/oom_kill.c: In function ‘out_of_memory’:
>    mm/oom_kill.c:1125:5: error: ‘struct oom_control’ has no member named ‘page’
>    oc->page = alloc_pages_before_oomkill(oc);
>      ^
> 
> Best wishes
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
