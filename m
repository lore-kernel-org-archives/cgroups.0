From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-3.12] cgroup: make css_for_each_descendant()
	and friends include the origin css in the iteration
Date: Thu, 8 Aug 2013 20:13:02 -0400
Message-ID: <20130809001302.GB13427@mtj.dyndns.org>
References: <20130804230703.GA12029@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=1Zrx0FNTdmifzMQCNNLQU+lZCADexjaJYJvZzkhmCZc=;
	b=mzVfU+v6DXsJg2vfH5O54jVlcjn6V23tBR+SNB92arr3rI1X4hphMsVHXoCzas0p2w
	ox9OqYetcrq6HjMgXh6ElV4kajOj4IKfjIVxASDU8nIq5U5XPB+vZILEgevQ2HKQS85o
	1fmufvJAF84vHWpPlbPdnPOWCI3+iEkqb2jjJOEGTVss3G/STs/hn42m1O0oXa9LXTHU
	HordzmedIoBP9sU0cPv6sm5Dd+Y268B0cEydXsrdJ6rS/PzCQ7SpUzuhhrVIG8c/JTv5
	X4w0+5EaeR8qViw0H+FLiuVFlTCCJzquuZctdhBbrFYuEi7vk/1qlq4toK1FjUTikGYp
	2OGA==
Content-Disposition: inline
In-Reply-To: <20130804230703.GA12029-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
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
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sun, Aug 04, 2013 at 07:07:03PM -0400, Tejun Heo wrote:
> Hello,
> 
> I've been wanting to do this for some time and given all the recent
> API updates now seems like a pretty good opportunity.  Verified
> freezer and blkcg.  The conversions are mostly straight forward but
> I'd much appreciate acks from controller maintainers.

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
