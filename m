From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup/cpuset: Update stale generate_sched_domains()
 comments
Date: Wed, 19 Dec 2018 11:36:53 -0800
Message-ID: <20181219193653.GA2509588@devbig004.ftw2.facebook.com>
References: <20181219133445.31982-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Nb/krCkYkipwbbjhtz1VO0hBalYD/mY6I6NOXTIsGYU=;
        b=TBRJwvLNp0Chy9DoHq+iGgubWhhX0bf7ikfLESW+nOXCKjAhg5rV5zb+dtLjhf1t1Y
         PEUmSOOOxJ39GU2hkOsIhwP5vcC0rRJNvYIdp3CkvNmeW20ly9wRBT2JEH5pE0Zgl6et
         Xz4aJW7UGx+f0yL3Tuu4J2CzOEVquxp7fsRxONZHl+a2MokniB4qgHy2s5n7GvQo6QSl
         Ayamqe9KIaSVv7JqBpkComwtVIYjnSAz4PDBLeuU9g163dVnsxewUahUqdUvmFgeMxlu
         eEYeaOOTckV9NYpkDIbQtr2Lsdqcl7SiM/4oLOSlStiqvR/VBHFMPEWhCPOMko1h4RLA
         c5JQ==
Content-Disposition: inline
In-Reply-To: <20181219133445.31982-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Dec 19, 2018 at 02:34:44PM +0100, Juri Lelli wrote:
> Commit fc560a26acce ("cpuset: replace cpuset->stack_list with
> cpuset_for_each_descendant_pre()") removed the local list (q)
> that was used to perform a top-down scan of all cpusets;
> however, comments mentioning it were not updated.
> 
> Update comments to reflect current implementation.
> 
> Signed-off-by: Juri Lelli <juri.lelli@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Prolly better to route through scheduler tree together with the second
patch?

Thanks.

-- 
tejun
