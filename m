From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup: add cgroup->serial_nr and implement
	cgroup_next_sibling()
Date: Wed, 22 May 2013 23:38:02 +0900
Message-ID: <20130522143802.GB18541@mtj.dyndns.org>
References: <1369101025-28335-1-git-send-email-tj@kernel.org>
	<1369101025-28335-4-git-send-email-tj@kernel.org>
	<20130522143636.GC16739@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=omGmD4AXv8megm6M9ZMZrH3qPEYayU8H3RTyHgTpDN8=;
	b=cuUusKH32Wu3ZCLsvc1SeFzDWkcatcoCOy6AdkvBFCpwP1ycMr7khKe6rme5pSDEYX
	BKOCOX3pzqDzEX9pd88Z5IdjphA/1t/Yb6sLQuC/Z38sxaZqZlhiLpwtw8lDSeTTSJ1q
	lQNKDQTdtPLRPIfdjGR1E3hSiD0Umna8hjYX8vuYUFZhJiVdR81DlL3sxfYxV3yrdtna
	ccau0ZjmR6HaGcSoNUZ3X7gCgRq1qBMzpBYIwEv4dAox3PnwM+wc8qKck85WZWr5d5Bv
	1WF0Qma8diDSJfzk4WISn66Y0e9tyaCdlmbuyUui39+dMu1TlsgNqV+MS9vv/pVft6on
	vf9A==
Content-Disposition: inline
In-Reply-To: <20130522143636.GC16739-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, May 22, 2013 at 10:36:36AM -0400, Aristeu Rozanski wrote:
> Hi Tejun,
> On Tue, May 21, 2013 at 10:50:23AM +0900, Tejun Heo wrote:
> > +	 * current cgroup is removed or iteration and reomval race.
>                                                       ^^^^^^^
> small typo

Yeap, Serge spotted it too.  Updated.

Thanks.

-- 
tejun
