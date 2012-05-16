From: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal
	optional
Date: Thu, 17 May 2012 00:33:05 +0200
Message-ID: <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
References: <20120330223423.GJ28934@google.com>
	<20120330223606.GK28934@google.com> <4F77B6BA.4070207@huawei.com>
	<20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:in-reply-to:references:from:date:message-id:subject:to
	:cc:content-type;
	bh=S/8J/yrfXDacad8XopNtm/N/CjAxPrWxPvJKwyIDkpo=;
	b=MSrNDvD13pfoyxfb4lGITx9WPjuuiwZxh5LpzWx9coOiu6JlEVxVKf/I1SeV0GF1wC
	fOf5Ij5Zbn0ve57CdLyqf9IMFDDlyobujUsthZ6fE4DCXeTti1Y4FbJ+JLmiYsfPfWHd
	eDD8mZOd5z3zO+k/r/3l5pkejdgydfBZmd7Xmfu0IXtFRwlpn6IK0nXvbntCOzelu0m2
	rLzuUjDexN14UW0POit2x3Fus9JwGQXjHVuaxdmmxhc6f0xzZYLT8VBAMaEO6nVbO0i+
	9YVTzL+MCOA42gPQJNsDGo54Cf4OExCgAb0clo6Bsxp6wxGrjM63HuaVAT5Njf8IhVUc
	UKYA==
In-Reply-To: <20120401185430.GA9230-RcKxWJ4Cfj1J2suj2OqeGauc2jM2gXBXkQQo+JxHRPFibQn6LdNjmg@public.gmane.org>
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
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hi Tejun,

On Sun, Apr 1, 2012 at 8:54 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Li.
>
> On Sun, Apr 01, 2012 at 10:00:26AM +0800, Li Zefan wrote:
>> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>
>> Both patches look good.
>>
>> Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>
> Alright, adding the patches to cgroup/for-3.5.

This patch allows for race when removing a cgroup since one of the
css's may still have a dentry ref when the cgroup is removed, no? Is
there a plan to deal with that before this patch gets pushed into 3.5?
