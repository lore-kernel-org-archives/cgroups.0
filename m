From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: use css->refcnt for cgroup
 reference counting
Date: Tue, 13 May 2014 12:59:42 -0400
Message-ID: <20140513165942.GG1866@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=s1DajzKVaBSOhwRC2yiHn0BoGxaOLFsfVDLC5bygbcQ=;
        b=R5zaAxfKP6J74eUMNA4NQRukboHctWZf6nEeIDq4a8zMyXfJWToDg7EYUiyUqzETAV
         QzXfx9hnsndmPl3rzH9FmNfM9Je/5Resl3dONdO3bfK9M2fJVwrWpzZ6eMnHYhWJ16Pf
         7wyG/8nQOQ6X5XPThhc0LzLmrZbPksp7KK7I+7jS6IH7Zxv339IgS7AlSQYfBmKg/foS
         HbTbg45Se2EoNnk4b8riLE5l1kzX6P5p/g8ghXOELY8r1p+JADKHrlmnVQBQPduD7koq
         gcmkda81NqAsYiNYkALG9d24ZAoNGcKDFaYtBgQbHIEW68cEz1HJWdWTQWS5PgNw3RoZ
         wQ0A==
Content-Disposition: inline
In-Reply-To: <1399670015-23463-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:13:26PM -0400, Tejun Heo wrote:
> and available in the following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git review-use-css-ref

Rebased on top of cgroup/for-3.16.

Thanks.

-- 
tejun
