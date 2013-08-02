From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 08/23] cgroup: pass around cgroup_subsys_state instead of
	cgroup in subsystem methods
Date: Fri, 2 Aug 2013 15:52:48 -0400
Message-ID: <20130802195248.GG29736@mtj.dyndns.org>
References: <1375393801-4817-1-git-send-email-tj@kernel.org>
	<1375393801-4817-9-git-send-email-tj@kernel.org>
	<20130802131901.GB25432@dhcp22.suse.cz>
	<20130802134305.GI25432@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=vErRPOFqDNEpPkaRETh8Ui5CfP1FWeepikiu0+ElG/Y=;
	b=t48TjmAQNMH0KzMoRNRPXUFgNuRuxAoSXXmy41YnCgoOdnj/DqHtPqJiSasg2fRZ89
	mGyrpHSuqnLE6BMGribpFGvGAskAhvB8LaUcdVAINEI6K6o8ByNiDJbN3n9NWHBLqRd+
	MKkBQODIi3O5H1BThPVN+PmONAMMyzlqqbT5jChwXX1HmObU9a8HZ1D6AJzuSdtjWjPX
	VcU9/VPoyWPmx0XTwGiYJF3iwmumJ2mtrgNfItFr2moNRuEjoB1IfMW5y7OFhSBYsmDy
	v9v7zPq54lSrac3UZTvpkQE5Gc2F1kUotrfMJVZWC9kl9OlEFF9zRrsfdCuhdO9UsjOv
	ClYg==
Content-Disposition: inline
In-Reply-To: <20130802134305.GI25432-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
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
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Aug 02, 2013 at 03:43:05PM +0200, Michal Hocko wrote:
> On Fri 02-08-13 15:19:01, Michal Hocko wrote:
> [...]
> > mem_cgroup_from_cont can go away now as well. Do you plan to remove it
> > in the series or later on?
> 
> Ohh, it goes in 21/23. Good

Heh, yeah, that one.

Thanks.

-- 
tejun
