From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Move maxable seq_file logic into a single place
Date: Thu, 24 Jan 2019 11:09:35 -0500
Message-ID: <20190124160935.GB12436@cmpxchg.org>
References: <20190124061718.GA15486@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cGQ/TMSWGm6i6QwmVNwOtbEz6FvQrTiXlzQK44rHJwA=;
        b=Vp9BWMMNtSD8xSzhnjEWyK0/Ha4ZrmqLfO7rXLLtXOYMU6a5cu7VVhnyEe8K2lx2I1
         /rfcdNbrUq1qGtrnNo3W8bcy/7whXZ+wPvxFaBn4lNJ35C48xU8cfqmJs7PBzVTBE1PU
         VqdUExIZne/b7ck8gktsq9gjbmK6VSzEocsS8MF+941BDqwcdCht1y+Sov8y6iEyBc7L
         wVLvILvIkOQoHBQEQAD8r2B1RsPLkuHQCgTxmTknmdIuZGpUGeC24ObTfdYapJuoOBru
         EWvTKEnOvE/3v7nz9v9Lbfzu2ViuHKN1YOFWKMSUfAkfgBsV4fh89kgL/iYCAA2MDmSN
         Tv6Q==
Content-Disposition: inline
In-Reply-To: <20190124061718.GA15486@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, Jan 24, 2019 at 01:17:18AM -0500, Chris Down wrote:
> memcg has a significant number of files exposed to kernfs where their
> value is either exposed directly or is "max" in the case of
> PAGE_COUNTER_MAX.
> 
> There's a fair amount of duplicated code here, since each file involves
> turning a seq_file to a css, getting the memcg from the css, safely
> reading the counter value, and then doing the right thing depending on
> whether the value is PAGE_COUNTER_MAX or not.
> 
> This patch adds the macro DEFINE_MEMCG_MAX_OR_VAL, which defines and
> implements a generic way to do this work, avoiding fragmenting logic.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com
> ---
> mm/memcontrol.c | 78 ++++++++++++-------------------------------------
> 1 file changed, 18 insertions(+), 60 deletions(-)

I think this increases complexity more than it saves LOC,
unfortunately.

The current situation is a bit repetitive, but much more obviously
correct. And we're not planning on adding many more of those memcg
interface files, so I this doesn't seem to be an improvement re:
maintainability and future extensibility of the code.
