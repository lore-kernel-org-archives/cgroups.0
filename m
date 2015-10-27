From: Aristeu Rozanski <arozansk@redhat.com>
Subject: Re: [PATCH] oom_kill: add option to disable dump_stack()
Date: Tue, 27 Oct 2015 13:51:41 -0400
Message-ID: <20151027175140.GC14722@redhat.com>
References: <1445634150-27992-1-git-send-email-arozansk@redhat.com>
 <20151026172012.GC9779@dhcp22.suse.cz>
 <20151026174048.GP15046@redhat.com>
 <20151027080920.GA9891@dhcp22.suse.cz>
 <20151027154341.GA14722@redhat.com>
 <20151027162047.GK9891@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151027162047.GK9891@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, cgroups@vger.kernel.org

Hi Michal,
On Tue, Oct 27, 2015 at 05:20:47PM +0100, Michal Hocko wrote:
> Yes this is a mess. But I think it is worth cleaning up.
> dump_stack_print_info (arch independent) has a log level parameter.
> show_stack_log_lvl (x86) has a loglevel parameter which is unused.
> 
> I haven't checked other architectures but the transition doesn't have to
> be all at once I guess.

Ok, will keep working on it then.

-- 
Aristeu

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
