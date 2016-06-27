From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Mon, 27 Jun 2016 09:54:57 -0500
Message-ID: <20160627145457.GA26980@mail.hallyn.com>
References: <1466694434-1420-1-git-send-email-toiwoton@gmail.com>
 <20160623213819.GP3262@mtj.duckdns.org>
 <53377cda-9afe-dad4-6bbb-26affd64cb3a@gmail.com>
 <20160624154830.GX3262@mtj.duckdns.org>
 <20160624155916.GA8759@mail.hallyn.com>
 <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org>
 <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Topi Miettinen <toiwoton@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

Quoting Tejun Heo (tj@kernel.org):
> Hello, Topi.
> 
> On Sun, Jun 26, 2016 at 3:14 PM, Topi Miettinen <toiwoton@gmail.com> wrote:
> > The parent might be able do it if proc/pid/xyz files are still
> > accessible after child exit but before its exit status is collected. But
> > if the parent doesn't do it (and you are not able to change it to do it)
> > and it collects the exit status without collecting other info, can you
> > suggest a different way how another process could collect it 100% reliably?
> 
> I'm not saying that there's such mechanism now. I'm suggesting that
> that'd be a more fitting way of implementing a new mechanism to track
> capability usages.

Hi Topi,

I think Eric was right a few emails earlier that the audit subsystem is
really the most appropriate answer to this.  (Perhaps sysctl-controllered?)
Combined with taskstats it would give you what you need.  Or you could even
use an empty new named cgroup controller, say 'none,name=caps', and then
look only at audit results for cgroup '/myapp' in the caps hierarchy.
