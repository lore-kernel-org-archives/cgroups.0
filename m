From: Glauber Costa <glommer@parallels.com>
Subject: Re: [RFC PATCH v1 0/4] cgroup quota
Date: Mon, 12 Mar 2012 13:36:22 +0400
Message-ID: <4F5DC396.60701@parallels.com>
References: <4F59E78A.7060903@oracle.com> <4F5C933F.3000409@parallels.com> <4F5C90DF.8070605@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <4F5C90DF.8070605@oracle.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: jeff.liu@oracle.com
Cc: jack@suse.cz, Lezcano <daniel.lezcano@free.fr>, Christopher Jones <christopher.jones@oracle.com>, Li Zefan <lizf@cn.fujitsu.com>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>, tj@kernel.org, Ben Myers <bpm@sgi.com>, Daniel@oss.sgi.com, lxc-devel@lists.sourceforge.net, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, cgroups@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, tytso@MIT.EDU

On 03/11/2012 03:47 PM, Jeff Liu wrote:
> And also, if there has already a project quota limits enforced outsides
> to a directly, but the user can still setup a smaller quota limit s
> through cgroup ,those limits just mixed up, but the smaller quota only
> be effected for those processes running at container.
>
>> >
>> >  What we really need here, is a way to have a privileged user inside a
>> >  container to create normal quotas (user, group) that he can configure,
>> >  and have this quota be always smaller than, say, a project quota defined
>> >  for the container from the outside. But cgroups is hardly the interface,
>> >  or place, for that: Usually, the processes inside the container won't
>> >  have access to their cgroups. They will contain the limits they are
>> >  entitled to, and we don't won't the processes to change that at will. So
>> >  tying it to cgroups does not solve the fundamental problem, which is how
>> >  we have the container admin to set up quotas...
> Sigh, exactly, I need some time to understand your opinions.  Thanks again.
>
>

My take on this is that you should stick to the quota interface. It 
seems to works well enough for people out there. This means, how quotas 
are configured, viewed, etc, should work with standard tools.

Now, we need some of those quotas to be tied to a particular mnt 
namespace (I believe namespaces to be the right isolation abstraction 
here, not cgroups), in the sense that they can only be active inside 
that mnt namespace. And then when you bill an inode, block, or anything 
else that quota limits, you bill it to any quota structure that is 
possibly interested in it. Right now the code bills it to one quota 
structure, the one that matches your UID, GID, etc (XFS may be a bit 
more skilled already here, I don't know)

