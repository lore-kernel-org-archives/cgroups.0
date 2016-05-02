From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Mon, 2 May 2016 12:06:04 -0400
Message-ID: <20160502160604.GR7822@mtj.duckdns.org>
References: <1462197681-6879-1-git-send-email-asarai@suse.de>
 <1462197681-6879-3-git-send-email-asarai@suse.de>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sImJDjtwRI+ptKJB2TKtLIQcW0/s3jUMnikZTqOHXlE=;
        b=DLW6Zy93dRiq/C+49NFmFmRRXwIajdk/dkhooRn8hxCU1XLDOmJnLc4vunwViihXGc
         pUlio9NxlMlErPsVX3RNf6aOn9PCNnq0wq2q6A067UATX4iLs2iz2TKC9lM9liEpr05u
         lrwI3lamBOjdm01fv04gRHiAVzUbrTq2PMWzTTMUCgDGuIKkiXpX5HMLzgeiT43o/tG/
         WanFqJZSU+AfiBRKveKl8JgTIRK3MqedRW1UMSKLVRZlS2qhLbw1v3A+kG099DGhjdW+
         vf4KO5GgQJV3G1LS8I5XDFMGKvYYVu4jSUOndpapwycZGCG5zxrV7g0WD5QjFUF5Eb3V
         mMjA==
Content-Disposition: inline
In-Reply-To: <1462197681-6879-3-git-send-email-asarai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai@suse.de>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev@opencontainers.org, Aleksa Sarai <cyphar@cyphar.com>

Hello,

On Tue, May 03, 2016 at 12:01:21AM +1000, Aleksa Sarai wrote:
> Allow an unprivileged processes to control subtrees of their associated
> cgroup, a necessary feature if an unprivileged container (set up with an
> unprivileged user namespace) wishes to take advantage of cgroups for its
> own subprocesses.
> 
> Change the mode of the cgroup directory for each cgroup association,
> allowing the process to create subtrees and modify the limits of the
> subtrees *without* allowing the process to modify its own limits. Due to
> the cgroup core restrictions and unix permission model, this allows for
> processes to create new subtrees without breaking the cgroup limits for
> the process.

I don't get why this is necessary.  What's wrong with the parent
setting up permission correctly for the namespace?

Thanks.

-- 
tejun
