From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v2 1/3] lib/vsprintf: Avoid redundant work with 0 size
Date: Mon, 31 Jan 2022 12:30:33 +0200
Message-ID: <Yfe6SfG4CqzWSaMM@smile.fi.intel.com>
References: <20220129205315.478628-1-longman@redhat.com>
 <20220129205315.478628-2-longman@redhat.com>
 <d99b3c4b-7b6e-529-6e4b-b91b65c92d81@google.com>
 <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643625101; x=1675161101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eGahUJSlFzxGqkP2PYspVj5bNJbqX3IGWEq9Q9r47kU=;
  b=Orca9j4LMBNhFM+ZiiDBWx4YuVIgkRGJ1a4hkXcl5gcSXfDbRn0RhXxB
   Zhm5ALaUEwigljxv1wWbhlc8kAHWDQm1qc5rAO1DlNvsZURmMB/ur/k9+
   g09apt+hA48/9e2erz3CxWDWFGA+6Bc3WyiG5/VxHQ/gnTu2XZmvhdcu+
   AWH2T58NEpimvaZnIMligktFTMR0FJ/s1yaixDJ5I7mBCRLRMwU7mGfE1
   YKhyQqkPYEhsn2XdnOi9PBrdWkkS+mcD9vNGgcZLSKcmz/VFkAPPByAUk
   GrgsjYqfedaCf9w1LgmCNE7RdPDuf8k2EphNlQLhU1hTDa4jnE85qwUAT
   A==;
Content-Disposition: inline
In-Reply-To: <Yfe5Bb3U6Uil7Y6g@smile.fi.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.com>, Steven Rostedt <rostedt@goodmis.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Ira Weiny <ira.weiny@intel.com>, Rafael Aquini <aquini@redhat.com>

On Mon, Jan 31, 2022 at 12:25:09PM +0200, Andy Shevchenko wrote:
> On Sun, Jan 30, 2022 at 12:49:37PM -0800, David Rientjes wrote:
> > On Sat, 29 Jan 2022, Waiman Long wrote:
> > 
> > > For *scnprintf(), vsnprintf() is always called even if the input size is
> > > 0. That is a waste of time, so just return 0 in this case.
> 
> Why do you think it's not legit?

I have to elaborate.

For *nprintf() the size=0 is quite useful to have.
For *cnprintf() the size=0 makes less sense, but, if we read `man snprintf()`:

  The  functions  snprintf() and vsnprintf() do not write more than size bytes
  (including the terminating null byte ('\0')). If the output was truncated due
  to this limit, then the return value is the  number of  characters (excluding
  the terminating null byte) which would have been written to the final string
  if enough space had been available. Thus, a return value of size or more
  means  that  the  output  was truncated.  (See also below under NOTES.)

  If an output error is encountered, a negative value is returned.

Note the last sentence there. You need to answer to it in the commit message
why your change is okay and it will show that you thought through all possible
scenarios.

-- 
With Best Regards,
Andy Shevchenko


