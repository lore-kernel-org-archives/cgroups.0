From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv3 8/8] cgroup: Add documentation for cgroup namespaces
Date: Wed, 7 Jan 2015 17:45:11 -0500
Message-ID: <20150107224430.GA28414@htj.dyndns.org>
References: <CAGr1F2HA6mzFwgp5ngX8P7=198-5CmCjLmuCJ8j3eQ08J2d9Qw@mail.gmail.com>
	<54AB15BD.8020007@nod.at> <87lhlgpyxk.fsf@x220.int.ebiederm.org>
	<CAGr1F2HSi_D07r2c5CKOsjSR1+58k9G2MrtACsd+HV6XKvJ7cA@mail.gmail.com>
	<54AB2992.6060707@nod.at>
	<CAGr1F2EGOUSEd3-G4PS0mq=9kU1nWG4CwHUOQaNUATepc11_Sw@mail.gmail.com>
	<54ACFC38.5070007@nod.at> <87fvbmir9q.fsf@x220.int.ebiederm.org>
	<20150107193059.GA1857@mail.hallyn.com>
	<87bnma6xwv.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=pWDumw6goduiU6pZe7Qlwx/ojSjLVLa/0D3WtB7pDXE=;
	b=npBrkXubUswQj9PvSRQVRr9Ffq83u+188olev9AwMQh4WLKV2tRd01nyCKZWupYtQd
	W2huZ9YV1zz0d116ioTed53mcMzZvX+kk3yxaz+GH+ndvStWIG5WRNPUqSpwzZOW8FBq
	8UFbvEkQ3w7AQ0xagI4WKG1gspjSYPgLgdjEslo0a9igpXUBXxSnhv/SnpQEmLJuGGSm
	xEVH1spOaR8bozkCSWV0IhpAASXMMPj3+ipZ0DTWoitF8No4Pol8C2ShqKJzOp36VoW7
	J+3nn0dYkLVD0/4gvcAkD/xVo/ymU0xdYjHi3TFvjyeT/7b/5w0EPyvUOYGOr1w40pL6
	EzoQ==
Content-Disposition: inline
In-Reply-To: <87bnma6xwv.fsf-JOvCrm2gF+uungPnsOpG7nhyD016LWXt@public.gmane.org>
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
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Jan 07, 2015 at 04:14:40PM -0600, Eric W. Biederman wrote:
> I see what you mean.  If it is indeed the case than a mount of cgroupfs
> using the unified hiearchy and can not specify which controllers are
> present under that mount that very significant bug and presents a very
> significant regression in user space flexibility.

The parent always controls which controllers are made available at the
children level.  Only if the parent enables a controller, its
children, whether they're namespaces or not, can choose to further
distribute resources using that controller.  It's a straight-forward
top-down thing.

-- 
tejun
