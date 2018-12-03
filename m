From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 3/7] cgroup: protect cgroup->nr_(dying_)descendants by
 css_set_lock
Date: Mon, 3 Dec 2018 08:17:06 -0800
Message-ID: <20181203161706.GL2509588@devbig004.ftw2.facebook.com>
References: <20181130234745.6756-1-guro@fb.com>
 <20181130234745.6756-4-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Y9j3PhmycYw6Qr1C9EO/9ht1q/JW9XQqu6X+2fdt+eE=;
        b=FK6aIGGXfd4GzHu+5VcLQc17PnjRnWyavIN+cclCpGigX1eY04H3IaHixevNcYdrIV
         CbaUQEVfobLySM5+4jHCAJABP26EZ1mAxFk3Gb1geQlOQt38QDRK2dsMPJysPzrNQGL3
         OylTo833d5NjdRqThEQ2H3Spg2CJXKUoJvrnFusBN5pvw5kqpWvRAw/0FhNl5/8UUFSI
         e8rI87deBXkjFMm34nUakxXZXvpylsw6gPlJmSNOd3+9hwf3wfekA+HnOs5aiQ4xQ2I6
         7A0O7gHBosNewqjcTCBIKF0/kP9e0rKpr3jgDS4G+MjG6KHdzj2CxHqf0O6e+NXQHK+F
         HQVw==
Content-Disposition: inline
In-Reply-To: <20181130234745.6756-4-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guroan@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dan Carpenter <dan.carpenter@oracle.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Roman Gushchin <guro@fb.com>

On Fri, Nov 30, 2018 at 03:47:41PM -0800, Roman Gushchin wrote:
> +	 * nr_descendants and nr_dying_descendants are protected
> +	 * by cgroup_mutex and css_set_lock.

Can you be a bit more specific - hold both for writes, either for
reads.

Thanks.

-- 
tejun
