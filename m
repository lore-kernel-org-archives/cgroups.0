From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: minor tweak for logic to get cgroup css
Date: Tue, 23 Jul 2019 15:48:30 -0700
Message-ID: <20190723224830.GH696309@devbig004.ftw2.facebook.com>
References: <20190703020749.22988-1-rocking@whu.edu.cn>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gcrDqc/0FKS5RAGoI3p47RWGgYc/38e7wO91/0hzW9U=;
        b=n9wK/DguRoFLTGgPSdnP/e65lyKdLvrZMutcIUo7uorMIpKj5yNx57aNEU/oNupI1o
         HbXUdM405Zpkdvwzm0PuesmMRixcYEnsOdcCUNq/mT0Z6p1JSc/OgcF5lHnzAWAXqrK7
         KsFfrCfYVziAaAmorTCFGKMkHNEvZoiR4N6a/UCU+O9d1OG5PJoNt0D55UC1DM1/VbqS
         iTj0aINX3tGoT4r5QsoDNNwUhmOjy7Z4AoxFSBsRLsabfLn+VCcC9f9YXNl1A0dSqnZQ
         /7bbe4xPXPwriCUiL5uKC86V1x0ipnv5ldTuyXozXPkP1j15LHE0tjB0/O1us2jnNtfP
         PF2g==
Content-Disposition: inline
In-Reply-To: <20190703020749.22988-1-rocking@whu.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peng Wang <rocking@whu.edu.cn>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Jul 03, 2019 at 10:07:49AM +0800, Peng Wang wrote:
> We could only handle the case that css exists
> and css_try_get_online() fails.
> 
> Signed-off-by: Peng Wang <rocking@whu.edu.cn>

Applied to cgroup/for-5.4.

Thanks.

-- 
tejun
