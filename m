From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET v2 cgroup/for-4.4] cgroup: make multi-process
 migration atomic
Date: Tue, 22 Sep 2015 12:48:20 -0400
Message-ID: <20150922164820.GC9761@mtj.duckdns.org>
References: <1441998022-12953-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=mTUEQ2VfmTiZKMHZKI0KD286IpaM0/ckIMwl+K+KvmE=;
        b=D5YuBNZ+siUVD6gGwNr22GE8KywhpCexVLdin7phRtar79DVnxIOcHcwMybp117yV0
         XkbdBrv7h4LrNIoGK5mRox6Fm142DVFCaBOMqLYy4HP2qMigLUyYlLYaUYZskWYWQGkP
         EFZkZDvqWEBhWQCq0S+7+J+TZDehz1mb5Skbjsd4asa3eYnxpKBlMcjjPh2TSJOCTO0X
         7+O5m9YQ2t2YFJedfBqzxnNfK7nWKt45MRQAE9aK/NI4YNnWNDa3bg4OecEw2seTpvyv
         xPgf9kAntY8+E0QBJnRSb3O7xNZa4UMIWlSPOb3zOW2Rl4XhEJg6ia7in1Gt330IzB54
         oWZQ==
Content-Disposition: inline
In-Reply-To: <1441998022-12953-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 11, 2015 at 03:00:17PM -0400, Tejun Heo wrote:
> This is v2 of atomic multi-process migration patchset.  This one
> slipped through crack somehow.  Changes from the last take[L] are.

Applied to cgroup/for-4.4.

Thanks.

-- 
tejun
