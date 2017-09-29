From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET REPOST for-4.15] cgroup, sched: cgroup2 interface for
 CPU controller (on basic acct)
Date: Fri, 29 Sep 2017 08:10:45 -0700
Message-ID: <20170929151045.GF15129@devbig577.frc2.facebook.com>
References: <20170925160019.683562-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=EFGOI/mQ96k1VdYMDdL0brHTeaMzpSOTGU5d3/j3Kzk=;
        b=lVKDLXxTV8EZ4aQ5LjhNrxczqfYgyGDTF3eGRX1Motyq4Lp+YMeObfhvGl4dJRs5a4
         JH/VWbTG6sWIjj2WoH/+/rh59imo8p0NMdJlZid/C5076h/vKaCHav9S2DsSgp6Hg1EO
         63kna3w5Xz8pvvtXfEiqdytXhbK1uHOoh3gYAfNlUTwA2dcym52Ff7vTX65buRhw/Met
         2G7qb1DA9SGfswhZwwJEvimKUrcCjMHPeojfn9jiIhtpp8Hvxs6CT1VmLvU6iilNhiaN
         pvjEfqxPNFKs3Y4yUxsj0vcobPQLELiQo9eQ2Ho7BfK4EGvloDH5+cq0FKZxyWuS7xC4
         VL8g==
Content-Disposition: inline
In-Reply-To: <20170925160019.683562-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com
Cc: longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Mon, Sep 25, 2017 at 09:00:17AM -0700, Tejun Heo wrote:
> These are two patches to implement the cgroup2 CPU controller
> interface.  Changes from the last revision[L].

Peter, Ping.

Thanks.

-- 
tejun
