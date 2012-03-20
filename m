From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 07/10] cgroup: remove cgroup_add_file[s]()
Date: Tue, 20 Mar 2012 09:01:21 -0700
Message-ID: <20120320160121.GC5684@google.com>
References: <1331940963-15756-1-git-send-email-tj@kernel.org>
	<1331940963-15756-8-git-send-email-tj@kernel.org>
	<87aa3bu094.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=KKh65ED/EWlgqvzfPvslt34Qoxjo2duU69366i9QKqc=;
	b=h7IpAWkQ20t38lZ97dQvSy1KS5srKSAtZAEg/g921fkUn+WUNjnLI4Wj67S5n1ww3p
	EELb/gbU6qhilAW94xfnrn2jgR/53tlxTXmHmi6+0cnzQlLu5enCH/NFDSGjBmbcZ/wc
	BUxUntkdYrYHv7r18t2PmGErXjS9a1+tiMmVb/hL1jbPFB9tsV95qG1ZtzRDw6VTryYb
	ZzZO41yQVDD2dDcFaJDTZuxFZyZULDsyzSSYEACQowSb5w4SWg/GsT3vuTcgEKsDa3Nr
	+q7WNuzSmTJYFmoX4iBGiohtb1RUyozdP6mSdJy9r13hFBZAMqkG1G9viFxZ1lGnM3aU
	7Gug==
Content-Disposition: inline
In-Reply-To: <87aa3bu094.fsf-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 20, 2012 at 02:17:51PM +0530, Aneesh Kumar K.V wrote:
> Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> writes:
> 
> > No controller is using cgroup_add_files[s]().  Unexport them, and
> > convert cgroup_add_files() to handle NULL entry terminated array
> > instead of taking count explicitly and continue creation on failure
> > for internal use.
> >
> 
> I am planning to use that in the HugeTLB extension of memcg.
> 
> http://article.gmane.org/gmane.linux.kernel.mm/75470
> 
> We need to have different limit and usage file for different HugeTLB
> page size supported.

Unless you have to alter available files cgroup-by-cgroup, you should
be fine.  If you're trying to create different set of files depending
on cgroup, it's confusing - change your interface.

Thanks.

-- 
tejun
