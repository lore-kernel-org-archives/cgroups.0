From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 2/3] memcg: disable pages allocation for swap cgroup
 on system booting up
Date: Tue, 4 Dec 2012 12:22:22 +0100
Message-ID: <20121204112222.GJ31319@dhcp22.suse.cz>
References: <50BDB5E0.7030906@oracle.com>
 <50BDB5FB.6080707@oracle.com>
 <20121204111721.GB1343@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121204111721.GB1343-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

On Tue 04-12-12 12:17:21, Michal Hocko wrote:
> On Tue 04-12-12 16:36:11, Jeff Liu wrote:
> > - Disable pages allocation for swap cgroup at system boot up stage.
> > - Perform page allocation if there have child memcg alive, because the user
> >   might disabled one/more swap files/partitions for some reason.
> > - Introduce a couple of helpers to deal with page allocation/free for swap cgroup.
> > - Introduce a new static variable to indicate the status of child memcg create/remove.
> 
> This approach doesn't work (unless I missed something). See bellow.

Wait a second I have missed that ctrl->map is already initialized.
Will get back to you...

-- 
Michal Hocko
SUSE Labs
