From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH v7 0/6] cgroup, blkcg: prevent dirty inodes to pin dying
 memory cgroups
Date: Fri, 4 Jun 2021 15:24:38 -0700
Message-ID: <YLqoJn/FmyqjQs0M@carbon.lan>
References: <20210604013159.3126180-1-guro@fb.com>
 <YLpMXmWvPsIK97ZE@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=tqawMRuN9akDj4PgOOjUXWd69bWm9UEVNyAJ582Ynjk=;
 b=DVUs1kzA0g0DEnxbk793938QyI+YIRuRKg3I08CXdRExKc0l9MeCFIPAMJ+irFh7zp2a
 qxYQ9ol3uwo1ntp13XaUUtMf+JsdVzVmzpaS3bJFoMC9IWHPggyYFrntyFvKNy8wR1We
 6OlgDz8Sq9VK8UeATFqLgxIgfQEa3op2rvE= 
Content-Disposition: inline
In-Reply-To: <YLpMXmWvPsIK97ZE@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org

On Fri, Jun 04, 2021 at 11:53:02AM -0400, Tejun Heo wrote:
> On Thu, Jun 03, 2021 at 06:31:53PM -0700, Roman Gushchin wrote:
> > To solve the problem inodes should be eventually detached from the
> > corresponding writeback structure. It's inefficient to do it after
> > every writeback completion. Instead it can be done whenever the
> > original memory cgroup is offlined and writeback structure is getting
> > killed. Scanning over a (potentially long) list of inodes and detach
> > them from the writeback structure can take quite some time. To avoid
> > scanning all inodes, attached inodes are kept on a new list (b_attached).
> > To make it less noticeable to a user, the scanning and switching is performed
> > from a work context.
> 
> Sorry for chiming in late but the series looks great to me and the only
> comment I have is the migration target on the last patch, which isn't a
> critical issue. Please feel free to add
> 
>  Acked-by: Tejun Heo <tj@kernel.org>

Thank you for taking a look and for acking the series!

I agree that switching to the nearest ancestor makes sense. If I remember
correctly, I was doing this in v1 (or at least planned to do), but then
switched to zeroing the pointer and then to bdi's wb.

I fixed it in v8 and pushed it here: https://github.com/rgushchin/linux/tree/cgwb.8 .
I'll wait a bit for Jan's and others feedback and will post v8 on Monday.
Hopefully, it will be the final version.

Btw, how are such patches usually routed? Through Jens's tree?

Thanks!
