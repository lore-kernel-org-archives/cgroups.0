From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC 4/4] cgroup: re-use the parent pointer in
 cgroup_destroy_locked()
Date: Wed, 2 Aug 2017 11:50:24 -0700
Message-ID: <20170802185023.GL2311718@devbig577.frc2.facebook.com>
References: <20170802165532.22277-1-guro@fb.com>
 <20170802165532.22277-5-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BFzcaPDLsuvzU8+rAUhR2KsNMD/C0teDOlRyiou1AQg=;
        b=OW6Z0nY1ly2033sQZTwoSF9sAJCfaHBPU+hBUTT8W49gGdnkxzbqoa11qa9i6SIgrh
         JtAW2l4T95JTZnz41TgwJKOAL1yBNCDE3kdPpKt9xgJApSW3/7GVhWqgUaxy9fsqmGtd
         X7vQPit5Xcmfg+i2u0i2mZvcLecmQWHjXDjLMUqMigdTKT9mvmlg0T3iT5bA/X+diOxM
         FF0mIeANcvgdpHQtXUgE5xeGfmGJd0RBD/6S1aUsmv9T3ETpB+RGu1Ryr1p5r50Gwkcx
         sS1YxAIs5kZ86dVTP3NaDxfyukOpf0dCNLxoZ2H6BhfNAfcPv4iDCkVXZZy3kkBdQHrP
         r6EQ==
Content-Disposition: inline
In-Reply-To: <20170802165532.22277-5-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: cgroups@vger.kernel.org, Zefan Li <lizefan@huawei.com>, Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel-team@fb.com, linux-kernel@vger.kernel.org

On Wed, Aug 02, 2017 at 05:55:32PM +0100, Roman Gushchin wrote:
> As we already have a pointer to the parent cgroup in
> cgroup_destroy_locked(), we don't need to calculate it again
> to pass as an argument for cgroup1_check_for_release().

Except for the minor nit earlier, everything in the series looks good
to me.

Thanks.

-- 
tejun
