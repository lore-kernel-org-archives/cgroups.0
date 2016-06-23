From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 23 Jun 2016 16:46:14 -0700
Message-ID: <20160623164614.cc871a52402fca6179bef246@linux-foundation.org>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Topi Miettinen <toiwoton@gmail.com>
Cc: linux-kernel@vger.kernel.org, luto@kernel.org, serge@hallyn.com, keescook@chromium.org, Jonathan Corbet <corbet@lwn.net>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP CGROUP" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On Thu, 23 Jun 2016 18:07:10 +0300 Topi Miettinen <toiwoton@gmail.com> wrote:

> There are many basic ways to control processes, including capabilities,
> cgroups and resource limits. However, there are far fewer ways to find
> out useful values for the limits, except blind trial and error.
> 
> Currently, there is no way to know which capabilities are actually used.
> Even the source code is only implicit, in-depth knowledge of each
> capability must be used when analyzing a program to judge which
> capabilities the program will exercise.
> 
> Add a new cgroup controller for monitoring of capabilities
> in the cgroup.

I'm having trouble understanding how valuable this feature is to our
users, and that's a rather important thing!

Perhaps it would help if you were to explain your motivation:
particular use cases which benefited from this, for example.

