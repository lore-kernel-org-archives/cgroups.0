From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: use a per-cgroup work for release agent
Date: Thu, 18 Sep 2014 13:23:25 -0400
Message-ID: <20140918172325.GC13573@mtj.dyndns.org>
References: <541A927B.8010308@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=MgGIbGn5oAxjYJ0lmzD+FcQsmotwVHPBXokLKSjHLjs=;
        b=xNzjPJlcgfvhRNxtAmF9R1vWqIWdKtKvoPH7YUE1n4dSOkck5ZUOAjFKVRxge7kReV
         XMWQVejbkkwoq7KdsUPwIAcS+LpRuQ/c/kqS6Ol7wykaQ3DpFvPVjLC4s778vrLfbLrs
         FRVMG9dofS3zOVj2yb7awCPpuxdB/lbmXeLwElnirXUSfKDVzvAWDbVsr5gzAiXT1ZUu
         qxM2BF+4kmomQQY2Z1GCDcxI8ov3E2m6Qa0qnUtb5gpJx2END7nT2DWTpVLkr1DZpnsi
         Afr4Q81PygIYst9A/ehReDb5bU9zV2JLd6JHfzSnSoe3QpmbsbzVUM59Jq2Lbsl2+GpM
         alnQ==
Content-Disposition: inline
In-Reply-To: <541A927B.8010308@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Thu, Sep 18, 2014 at 04:06:19PM +0800, Zefan Li wrote:
> Instead of using a global work to schedule release agent on removable
> cgroups, we change to use a per-cgroup work to do this, which makes
> the code much simpler.
> 
> v2: use a dedicated work instead of reusing css->destroy_work. (Tejun)
> 
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Applied to cgroup/for-3.18.

Thanks.

-- 
tejun
