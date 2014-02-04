From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: the performance of cgroup regarding resource isolation
Date: Tue, 04 Feb 2014 10:59:55 -0800
Message-ID: <87ha8ek8k4.fsf@xmission.com>
References: <CADoVA9rZn7mu6hmsqE9qtsg76PJo5XE=bmqfpeB3xGNrOw1oHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CADoVA9rZn7mu6hmsqE9qtsg76PJo5XE=bmqfpeB3xGNrOw1oHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(ricky l.'s message of "Tue, 4 Feb 2014 11:28:47 -0500")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ricky l <rickylee0815-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

ricky l <rickylee0815-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> writes:

> Can anyone help me to find documents/blog that describes the
> performance of cgroup mainly for CPU resource isolation? I am curious
> how well (or accurately) it isolates different groups with different
> cfs_quota or cpu.shares. I am also curious how instantaneous the
> change of the values take effect. Can someone enlighten me? thx.

Write a micro benchmark to test the case you care about.

If you really care that is the only way to know.

Eric
