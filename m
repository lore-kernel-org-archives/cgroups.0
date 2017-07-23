From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup/for-4.13-fixes] cgroup: fix error return value
 from cgroup_subtree_control()
Date: Sun, 23 Jul 2017 08:15:48 -0400
Message-ID: <20170723121548.GB1498614@devbig577.frc2.facebook.com>
References: <20170723121415.GA1498614@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=omv/bn6x33h8sG/zOYRSPtQwCOKZ1BTJETWkziBCMeg=;
        b=h7cgk+QGhyGRw8GcyUhn1Bb9pVqbmBIlsBhNZykwZ3Gl7mCe5oZFqOKOMorpmRRcxP
         OxzzVETpeo8yFcRNB8Uvb0QR5j2ZOffyCcVkaLdCkla4OrlKoMf3MWCbCcOgm1ZRreT9
         Y/vftvEWDV+l+elWZ4pGrP6WvPcvjhMKZCrhNwp4qgyXDrdnSiggkjuG/xYEBsYJwrBb
         /xbETIqWyq0Jb9EdiqVAWY3z2/7xFW60NXtu6iJOu0a0hmq8wTr+G8N8XfIN3Xy0LXHZ
         93AmLEnfvnpkGWsHSxkpr9xLQlmxZpiHgl1pqFvaUPuh60M9vtu/7NUEyeDOTkv0x8Wb
         qjEA==
Content-Disposition: inline
In-Reply-To: <20170723121415.GA1498614@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Sun, Jul 23, 2017 at 08:14:15AM -0400, Tejun Heo wrote:
> While refactoring, f7b2814bb9b6 ("cgroup: factor out
> cgroup_{apply|finalize}_control() from
> cgroup_subtree_control_write()") broke error return value from the
> function.  The return value from the last operation is always
> overridden to zero.  Fix it.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: stable@vger.kernel.org # v4.6+

Applying to cgroup/for-4.13-fixes.

Thanks.

-- 
tejun
