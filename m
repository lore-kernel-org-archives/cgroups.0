From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Date: Sun, 27 Oct 2013 05:04:29 -0700
Message-ID: <20131027050429.7fcc2ed5.akpm@linux-foundation.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
	<1382859876-28196-3-git-send-email-gthelen@google.com>
	<20131027112255.GB14934@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131027112255.GB14934@mtj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, handai.szj@taobao.com, x86@kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Sun, 27 Oct 2013 07:22:55 -0400 Tejun Heo <tj@kernel.org> wrote:

> We probably want to cc stable for this and the next one.  How should
> these be routed?  I can take these through percpu tree or mm works
> too.  Either way, it'd be best to route them together.

Yes, all three look like -stable material to me.  I'll grab them later
in the week if you haven't ;)

The names of the first two patches distress me.  They rather clearly
assert that the code affects percpu_counter.[ch], but that is not the case. 
Massaging is needed to fix that up.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
