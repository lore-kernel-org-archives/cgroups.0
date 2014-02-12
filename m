From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] cgroup: remove cgroup->name
Date: Wed, 12 Feb 2014 03:27:13 -0500
Message-ID: <20140212082713.GD7984@mtj.dyndns.org>
References: <1391877509-10855-1-git-send-email-tj@kernel.org>
	<1391877509-10855-7-git-send-email-tj@kernel.org>
	<52FB2834.3090408@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=cs44n4AXwxyzcgEfqLRg2w7Uo77+G815SqWBJLungiE=;
	b=qOjYhs3Kybx4ZE2RNP6fwaT2LgY4QA/rz8RRkBJS3M9ZGgO38aZVNvEa4FpQOQqT3Q
	L0u6gntm/5SmRhl8UAcl49bO+HoEcEvOHOySqE/fQKx/U6EH1/yGaZCYCPIyjYhoqnsG
	C/3i4kfLtg6nqBzq5suOQEbJplTfSbyGFSPe/Fg67e2G2pFBN8wFiU7J2d91zwOq3vnL
	xa6vlSjyKUfwp5bOISv0yTqKaRdjPFVDPUgOVbZ+XgV/JZVu7CyieMndEloMsdPWpguw
	pwb86hPDoFgJRjpAeZzeVDyJ2lpo14FgCAfPpe1WqVo2cLu827N4E339wBluZlLMAZuU
	KE8w==
Content-Disposition: inline
In-Reply-To: <52FB2834.3090408-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
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
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Feb 12, 2014 at 03:52:20PM +0800, Li Zefan wrote:
> The caller won't check the return value but pass it to printk/seq_printf,
> but now cgroup_path() might return -ENAMETOOLONG..

cgroup_path() returns NULL on overflow which printk handles fine, no?

Thanks.

-- 
tejun
