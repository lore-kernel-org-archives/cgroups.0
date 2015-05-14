From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: Possible bug - LTP failure for memcg
Date: Thu, 14 May 2015 14:12:48 +0200
Message-ID: <20150514121248.GG6799@dhcp22.suse.cz>
References: <55536DC9.90200@kyup.com>
 <20150514092145.GA6799@dhcp22.suse.cz>
 <20150514103148.GA5066@rei.suse.de>
 <20150514115641.GE6799@dhcp22.suse.cz>
 <20150514120142.GG5066@rei.suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150514120142.GG5066-J5syqNJeCN4b1SvskN2V4Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Cyril Hrubis <chrubis-AlSwsSmVLrQ@public.gmane.org>
Cc: Nikolay Borisov <kernel-6AxghH7DbtA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu 14-05-15 14:01:42, Cyril Hrubis wrote:
> Hi!
> > > The previous testcases does exactly this but moves the process to the
> > > parent with:
> > > 
> > > echo $pid > ../tasks
> > > 
> > > Before it tries the force_empty and expects it to succeed.
> > > 
> > > Was this some old implementation limitation that has been lifted
> > > meanwhile?
> > 
> > OK, now I remember... f61c42a7d911 ("memcg: remove tasks/children test
> > from mem_cgroup_force_empty()") which goes back to 3.16. So the test
> > case is invalid.
> 
> Then please send a patch to remove the test.

I think we can still fix both tescases and expect not to fail with
regular mmap but fail it with unreclaimable memory (e.g. disallow
swapout or use mlock).
-- 
Michal Hocko
SUSE Labs
