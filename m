From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-3.15-fixes] blkcg: use trylock on
 blkcg_pol_mutex in blkcg_reset_stats()
Date: Mon, 5 May 2014 12:38:21 -0400
Message-ID: <20140505163821.GM11231@htj.dyndns.org>
References: <5363C04B.4010400@oracle.com>
 <20140505163730.GL11231@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1owiOvQcYihcRh+gbqHkF4qErFghbHH0q7aoMpe6YA4=;
        b=T1SAOU+wsdI0m1TTbFltCwtNQjpQ7lKU+zuuJRvl+VJjuSPBwd+PJP+zVIXIF6RzzD
         l1jFmqoQ7PYk1N08GQV3mt+6SYO1yap81TCgV0OSJJnWcHA5sFB/eXuj2zqXm5mnV82m
         hbB5CHtPXcJbyzEnqWb7xKyMU0+KVLmhpu2RNo5ojiHH0rdlGn5OXyu8QZPZTVjZC/MF
         nFjurO4MMiyh1Qkdcgq0g5d9OXkrSd5QmMM31QNj6pMqBhLYCCT1spEzFfpqtoqMpJEt
         outYEQ/8BykK8CwBL7rWgcpKx3Dyy6fh2DlAHX38RVP3MTv3hC/XsPfvtVuw7lfePfAq
         WZ7A==
Content-Disposition: inline
In-Reply-To: <20140505163730.GL11231@htj.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: axboe@kernel.dk, Sasha Levin <sasha.levin@oracle.com>, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>, cgroups@vger.kernel.org

On Mon, May 05, 2014 at 12:37:30PM -0400, Tejun Heo wrote:
> During the recent conversion of cgroup to kernfs, cgroup_tree_mutex
> which nests above both the kernfs s_active protection and cgroup_mutex
> is added to synchronize cgroup file type operations as cgroup_mutex
> needed to be grabbed from some file operations and thus can't be put
> above s_active protection.

Ooh, I verified that the patch removes the lockdep warning and am
routing it through cgroup/for-3.15-fixes.  If there's any objection,
please let me know.

Thanks!

-- 
tejun
