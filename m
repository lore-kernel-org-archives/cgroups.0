From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: pids: use {READ,WRITE}_ONCE for pids->limit
 operations
Date: Mon, 14 Oct 2019 08:41:36 -0700
Message-ID: <20191014154136.GF18794@devbig004.ftw2.facebook.com>
References: <20191012010539.6131-1-cyphar@cyphar.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BUs6ww2wp2HkRKO5Ig1yFUSfYWRm/mJFXsejJnbtOqs=;
        b=oQOzhgiLemf2MFAncmQNwr1h9wmPYZjB9Mhg6CjWxiGAzLmQaUUeRd3rfj1VMVUgXB
         T/o3WuHsOpozELcayBmb+2CMX2fA22LFOds2rvcs7WSjLFP2WyZn5MlPTOwV0zJEUGk/
         0AH3sWGN4COj6efHDv2YZyJZGaaUl/5jK7q8NriAucA/qduGE/SI5d3R8Kq47J5m2EXo
         AP2tAQNe4qD4gD8HfxptPoFq51uauD9hmaTSpJmi6PdyFi/oYoXjibGgvoME/Pzo/d3Y
         7pv6CwmKL8neIiyMfpoFvvqHNK7ArxkXw1SmJyNxDEi5/K0k6Cd9X3hcnMsDpkSu1bUO
         /G1A==
Content-Disposition: inline
In-Reply-To: <20191012010539.6131-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org

On Sat, Oct 12, 2019 at 12:05:39PM +1100, Aleksa Sarai wrote:
> Because pids->limit can be changed concurrently (but we don't want to
> take a lock because it would be needlessly expensive), use the
> appropriate memory barriers.

I can't quite tell what problem it's fixing.  Can you elaborate a
scenario where the current code would break that your patch fixes?

Thanks.

-- 
tejun
