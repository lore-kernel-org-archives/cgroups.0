From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Mon, 31 Jan 2022 12:25:09 +0200
Message-ID: <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643624778; x=1675160778;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rnpGhLBeO/HdBBinrNjhSH3ZdFwzc3ZAIZeFErKuU6A=;
  b=SkcJ7eA6RZTlScMiOO024trJbZNNtkF46WMRtc2T2aFFxeynxquzaHMG
   GhnJnnYlvl14f/ZDy0DtaeKE0lvPuhPRWlXvxUSqS3asEStOYSn7IqF7I
   uIN57GTBjzXVJeEqWPILmoFwjpYuN02ISa1hUgjUepUy/0ztd1JyiEoD9
   bJTa7VtP8nlsxJ9Fwby4r24R8edKGLqyUIn+3pcAE23OxEHfKTeOKq2jt
   2pwzLcWHD7EmiwPWG2PO9LtV4L9MzLlFZCN6ZnU1Y9joQXMA6uh7iCKuz
   f25Ge8H6B1ZAycugVAwCfF/19f4sB1sI3VjMkcTYag0xSaIVe1HeAAhoZ
   A==;
Content-Disposition: inline
In-Reply-To: <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Rafael Aquini <aquini@redhat.com>

On Sun, Jan 30, 2022 at 12:49:37PM -0800, David Rientjes wrote:
> On Sat, 29 Jan 2022, Waiman Long wrote:
> 
> > For *scnprintf(), vsnprintf() is always called even if the input size is
> > 0. That is a waste of time, so just return 0 in this case.

Why do you think it's not legit?

-- 
With Best Regards,
Andy Shevchenko


