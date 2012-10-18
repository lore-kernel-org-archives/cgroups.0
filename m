From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 5/6] memcg: make mem_cgroup_reparent_charges non failing
Date: Thu, 18 Oct 2012 15:48:07 -0700
Message-ID: <20121018224807.GT13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6Vf78MAEPy5TvvcvhAlOuaCfXNz/qnWGeqJ1rYpm61w=;
        b=ZHIzYjS6QJnZXUsbiSdSmMWJYbrMKhpl41brqP7KQSQa/Qq1u+Z5fk2tP7kX1ehxGD
         Xj06WasGMen0VYv0SiA6CcZUWS80GW2fcReoFp1V6srSGQNaShDXNlD+GQRuIn9u9fgy
         G/GjPA6TAoFg4y8cEgwM3Pl9Quowj5PT3OEKK3Gd3NMpUb3mZPr9vAEGQkfIc8vaQCEo
         h01fH68w7n6oL6oI2ggGCDO4Pccy0urmrYHFglvlwQPeRjW0WSNJaGnC+zKgGFsJvu1l
         oFIa7vk451tFpCcg6teNLU5SZpeUp4jsqzj/U/Fj2sYx4mbXuEvbDEursxcur+RQoZ6M
         X5Zg==
Content-Disposition: inline
In-Reply-To: <1350480648-10905-6-git-send-email-mhocko@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

On Wed, Oct 17, 2012 at 03:30:47PM +0200, Michal Hocko wrote:
> Now that pre_destroy callbacks are called from within cgroup_lock and
> the cgroup has been checked to be empty without any children then there
> is no other way to fail.
> mem_cgroup_pre_destroy doesn't have to take a reference to memcg's css
> because all css' are marked dead already.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
