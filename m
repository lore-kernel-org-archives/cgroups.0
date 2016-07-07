From: Petr Mladek <pmladek@suse.com>
Subject: Re: [PATCH] capabilities: add capability cgroup controller
Date: Thu, 7 Jul 2016 11:16:46 +0200
Message-ID: <20160707091645.GG3238@pathway.suse.cz>
References: <20160624163527.GZ3262@mtj.duckdns.org>
 <20160624165910.GA9675@mail.hallyn.com>
 <20160624172447.GA3262@mtj.duckdns.org>
 <47890d79-0891-dd13-4f60-e7e5f1f3fed3@gmail.com>
 <CAOS58YMxz5HfJUayqjw+SPj485M+wquTqQouk367rV2mfvVRHg@mail.gmail.com>
 <20160627145457.GA26980@mail.hallyn.com>
 <58938c8b-aca6-a5b8-9533-58e78d878e85@gmail.com>
 <CAOS58YM+h0w_UciXLbiJcKizPkXV66FL57LT7Mc+RRWspN+Y2Q@mail.gmail.com>
 <20160627194941.GA31843@mail.hallyn.com>
 <218f2bef-5e5e-89c4-154b-24dc49c82c31@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <218f2bef-5e5e-89c4-154b-24dc49c82c31@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Topi Miettinen <toiwoton@gmail.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>, luto@kernel.org, Kees Cook <keescook@chromium.org>, Jonathan Corbet <corbet@lwn.net>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Serge Hallyn <serge.hallyn@canonical.com>, James Morris <james.l.morris@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, David Howells <dhowells@redhat.com>, David Woodhouse <David.Woodhouse@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CAPABILITIES" <linux-security-module@vger.kernel.org>

On Sun 2016-07-03 15:08:07, Topi Miettinen wrote:
> The attached patch would make any uses of capabilities generate audit
> messages. It works for simple tests as you can see from the commit
> message, but unfortunately the call to audit_cgroup_list() deadlocks the
> system when booting a full blown OS. There's no deadlock when the call
> is removed.
> 
> I guess that in some cases, cgroup_mutex and/or css_set_lock could be
> already held earlier before entering audit_cgroup_list(). Holding the
> locks is however required by task_cgroup_from_root(). Is there any way
> to avoid this? For example, only print some kind of cgroup ID numbers
> (are there unique and stable IDs, available without locks?) for those
> cgroups where the task is registered in the audit message?

I am not sure if anyone know what really happens here. I suggest to
enable lockdep. It might detect possible deadlock even before it
really happens, see Documentation/locking/lockdep-design.txt

It can be enabled by

   CONFIG_PROVE_LOCKING=y

It depends on

    CONFIG_DEBUG_KERNEL=y

and maybe some more options, see lib/Kconfig.debug


Best Regards,
Petr
