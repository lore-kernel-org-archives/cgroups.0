From: Mike Rapoport <rppt@linux.ibm.com>
Subject: Re: [PATCH v3 7/7] cgroup: document cgroup v2 freezer interface
Date: Tue, 20 Nov 2018 15:06:21 +0100
Message-ID: <20181120140621.GC24627@rapoport-lnx>
References: <20181117003830.15344-1-guro@fb.com>
 <20181117003830.15344-8-guro@fb.com>
 <20181117080227.GA22672@rapoport-lnx>
 <20181119174241.GA7273@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181119174241.GA7273@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <guroan@gmail.com>, Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>

On Mon, Nov 19, 2018 at 05:42:48PM +0000, Roman Gushchin wrote:
> On Sat, Nov 17, 2018 at 12:02:28AM -0800, Mike Rapoport wrote:
> > Hi,
> > 
> > On Fri, Nov 16, 2018 at 04:38:30PM -0800, Roman Gushchin wrote:
> > > Describe cgroup v2 freezer interface in the cgroup v2 admin guide.
> > > 
> > > Signed-off-by: Roman Gushchin <guro@fb.com>
> > > Cc: Tejun Heo <tj@kernel.org>
> > > Cc: linux-doc@vger.kernel.org
> > > Cc: kernel-team@fb.com
> > > ---
> > >  Documentation/admin-guide/cgroup-v2.rst | 26 +++++++++++++++++++++++++
> > >  1 file changed, 26 insertions(+)
> > > 
> > > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > > index 184193bcb262..a065c0bed88c 100644
> > > --- a/Documentation/admin-guide/cgroup-v2.rst
> > > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > > @@ -862,6 +862,8 @@ All cgroup core files are prefixed with "cgroup."
> > >  	  populated
> > >  		1 if the cgroup or its descendants contains any live
> > >  		processes; otherwise, 0.
> > > +	  frozen
> > > +		1 if the cgroup is frozen; otherwise, 0.
> > > 
> > >    cgroup.max.descendants
> > >  	A read-write single value files.  The default is "max".
> > > @@ -895,6 +897,30 @@ All cgroup core files are prefixed with "cgroup."
> > >  		A dying cgroup can consume system resources not exceeding
> > >  		limits, which were active at the moment of cgroup deletion.
> > > 
> > > +  cgroup.freeze
> > > +	A read-write single value file which exists on non-root cgroups.
> > > +	Allowed values are "0" and "1". The default is "0".
> > > +
> > > +	Writing "1" to the file causes freezing of the cgroup and all
> > > +	descendant cgroups. This means that all belonging processes will
> > > +	be stopped and will not run until the cgroup will be explicitly
> > > +	unfrozen. Freezing of the cgroup may take some time; when the process
> > 
> > "when the process is complete" sounds somewhat ambiguous, it's unclear
> > whether freezing is complete or the process that's being frozen is
> > complete.
> > 
> > Maybe "when this action is completed"?
> > 
> > > +	is complete, the "frozen" value in the cgroup.events control file
> > > +	will be updated and the corresponding notification will be issued.
> > 
> > Can you please clarify how exactly cgroup.events would be updated?
> > 
> > > +	Cgroup can be frozen either by its own settings, either by settings
> > 
> >       ^ A cgroup ... and maybe there are more "a" and "the" that should be
> > fixed, it's hard for me to tell.
> > 
> > Also, I believe "either ..., or ..." sounds better than "either ...,
> > either ..."
> > 
> > > +	of any ancestor cgroups. If any of ancestor cgroups is frozen, the
> > > +	cgroup will remain frozen.
> > > +
> > > +	Processes in the frozen cgroup can be killed by a fatal signal.
> > > +	They also can enter and leave a frozen cgroup: either by an explicit
> > > +	move by a user, either if freezing of the cgroup races with fork().
> > 
> > ditto
> > 
> > > +	If a cgroup is moved to a frozen cgroup, it stops. If a process is
> > 
> >             ^ process?
> > 
> > > +	moving out of a frozen cgroup, it becomes running.
> > 
> >        ^ moved
> 
> Hello, Mike!
> 
> Thanks for the review! I agree with all comments above; fixes queued for v4.
> 
> > 
> > > +	Frozen status of a cgroup doesn't affect any cgroup tree operations:
> > > +	it's possible to delete a frozen (and empty) cgroup, as well as
> > > +	create new sub-cgroups.
> > 
> > Maybe it's also worth adding that freezing a process has no effect on its
> > memory consumption, at least directly.
> 
> Hm, isn't it the expected behavior?

You'd be surprised ;-)
Just recently I had a couple of questions about the memory consumption of
the frozen processes.
 
> In any case, I assume that cgroup.freeze knob description is not the best place
> for a such explanations. Maybe it's better to add a standalone paragraph with
> the description of the frozen process state, what's expected to work, what's
> not, etc. I'd return to this question a bit later, when we'll agree on the user
> interface and the implementation.

Sure.
 
> Thanks!
> 

-- 
Sincerely yours,
Mike.

