From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH cgroup/for-4.8] cgroup: allow NULL return from
 ss->css_alloc()
Date: Tue, 21 Jun 2016 14:14:04 -0400
Message-ID: <20160621181404.GB4501@cmpxchg.org>
References: <20160621170624.GK3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160621170624.GK3262@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jun 21, 2016 at 01:06:24PM -0400, Tejun Heo wrote:
> cgroup core expected css_alloc to return an ERR_PTR value on failure
> and caused NULL deref if it returned NULL.  It's an easy mistake to
> make from an alloc function and there's no ambiguity in what's being
> indicated.  Update css_create() so that it interprets NULL return from
> css_alloc as -ENOMEM.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

Would it be better to remove the error code instead and have everybody
return NULL? AFAICS, everybody is returning either the object or the
-ENOMEM error code right now.

What error condition is there for an allocation function?
