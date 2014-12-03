From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH 2/2] cgroups: Documentation: fix trivial typos and wrong
 paragraph numberings
Date: Wed, 3 Dec 2014 11:43:08 -0500
Message-ID: <20141203114308.3898e74e@lwn.net>
References: <1417607625-2775-1-git-send-email-sj38.park@gmail.com>
	<1417607625-2775-2-git-send-email-sj38.park@gmail.com>
	<20141203090113.359198f6@lwn.net>
	<alpine.DEB.2.10.1412040033120.1819@hxeon>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.10.1412040033120.1819@hxeon>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: SeongJae Park <sj38.park@gmail.com>
Cc: tj@kernel.org, lizefan@huawei.com, trivial@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>

On Thu, 4 Dec 2014 00:36:09 +0900 (KST)
SeongJae Park <sj38.park@gmail.com> wrote:

> I based it on latest linux-next tree.
> 
> Looks like I should based it on linux-docs tree. I will do for my later 
> patches for documentations.
> 
> Below is the patch 2 based on linux-docs tree.

Thanks, but the best thing to do might be to have Andrew Morton take the
original patch. His tree already contains the other changes to that file;
keeping things there will help to avoid conflicts and dependencies during
the merge window.

Thanks,

jon
