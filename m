From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.15] cgroup: more cleanups
Date: Thu, 13 Feb 2014 06:59:23 -0500
Message-ID: <20140213115923.GA29795@mtj.dyndns.org>
References: <1391953964-22088-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=sender:date:from:to:cc:subject:message-id:references:mime-version
	:content-type:content-disposition:in-reply-to:user-agent;
	bh=UHirf76Lu+L/8LkRYwGWzQiMF0RfhZGSNDpCi9w49n8=;
	b=Mfh5g+e4X4FiURVEWnT2g6KgkrnsipB4iASVbtuPiGjnKBAqeM5VTSKhWLhCiT5w7I
	Y/EbpxnL9OGUIG14xC04ntZCzmOoyI0LZ6e+aXfIMIEttnxIPy51Cr6Sx0KIYuqeKLi+
	N3qI83UjmbWWm0Uk/C5K6rrIeV2bQ3zjtCJlqwQdjjPKcs9f/qO5/HshjXAlOMDX1TJK
	djmUqAPiFxUBgIMGOuIF6W8L13qdbzYsFOYCW8U9eYzWCuCJlu3oD2HnFi4mJzhI+qrm
	5pHc/uOPzSr9RlQiysCr3Vz0o+LMgipxlds8Pm3/OATiRYWUKclgBhjFtElYsPLr1sw4
	hRiQ==
Content-Disposition: inline
In-Reply-To: <1391953964-22088-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
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
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Feb 09, 2014 at 08:52:28AM -0500, Tejun Heo wrote:
> Hello,
> 
> This series contains assorted cleanups which also prepare for the
> planned migration taskset handling update.

Applied to cgroup/for-3.15.  Thanks.

-- 
tejun
