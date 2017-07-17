From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 14/15] kernel: convert futex_pi_state.refcount from
 atomic_t to refcount_t
Date: Mon, 17 Jul 2017 16:25:36 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1707171607050.2185@nanos>
References: <1500288206-12074-1-git-send-email-elena.reshetova@intel.com> <1500288206-12074-15-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1500288206-12074-15-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, keescook@chromium.org

On Mon, 17 Jul 2017, Elena Reshetova wrote:

> Subject: kernel: convert futex_pi_state.refcount from atomic_t to refcount_t

Several people including myself told you already, that subjects consist of

SUBSYSTEMPREFIX: Concise description

It's easy enough to figure the prefix out by looking at the output of 'git
log path/of/changed/file'.

Concise descriptions are not lengthy sentences with implementation
details. They should merily describe the problem/concept of change. The
details go into the changelog. IOW, something like:

	"PROPERPREFIX: Convert to refcount API"

would be sufficient.

> refcount_t type and corresponding API should be
> used instead of atomic_t when the variable is used as
> a reference counter. This allows to avoid accidental
> refcounter overflows that might lead to use-after-free
> situations.

Copying the same sentence over and over avoids thinking about a proper
changelog, right? You fail to explain, how you come to the conclusion that
futex_pi_state.refcount is a pure reference counter (aside of the name) and
therefor can be safely converted to refcount_t.

Other than that, the patch itself is fine.

Thanks,

	tglx
