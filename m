From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: LTP test suite triggers LOCKDEP_CIRCULAR on linux-next
Date: Mon, 31 Jan 2022 09:21:03 -0800
Message-ID: <Yfgaf885yDFPtjJH@carbon.dhcp.thefacebook.com>
References: <87mtjzslv7.fsf@oc8242746057.ibm.com>
 <YeI78TMjU12qRmQ8@carbon.dhcp.thefacebook.com>
 <YfgWAuzAo2WDyPH+@carbon.dhcp.thefacebook.com>
 <87r18nj01l.fsf@oc8242746057.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=JpVtCV9IOqxzDBEiavCiENiaFtF7Sl4yZqdD0/YEnNI=;
 b=oKKnWppMlaketjaoAuwIQalrtgzpdp6Jmiw1BOYvqhS6llUry640BzpL3cH/ucfKDcYi
 nOQlJRFF9MRZrXeembrXK9eCkA24n9piZZTvlv1sDF5plH9MAsiLVDcuKZMtjBK9NYC5
 Bt+YP89/ly0BS1sbA6TTlA2/dlgkzAdGiQA= 
Content-Disposition: inline
In-Reply-To: <87r18nj01l.fsf-NkpGzEVru+PSGbUrCpOCvVaTQe2KTcn/@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Jan 31, 2022 at 06:19:02PM +0100, Alexander Egorenkov wrote:
> Hi Roman,
> 
> 
> Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org> writes:
> 
> > On Fri, Jan 14, 2022 at 07:13:53PM -0800, Roman Gushchin wrote:
> >> On Thu, Jan 13, 2022 at 04:20:44PM +0100, Alexander Egorenkov wrote:
> >> 
> >> Hi Alexander!
> >> 
> >> Can you, please, check if the following patch is fixing the problem for you?
> >> 
> >> Thanks a lot in advance!
> >
> > Friendly ping.
> >
> > Thanks!
> 
> I'm very sorry for late response,
> we just noticed your mails :(
> We installed your patch and today's CI run will use it for testing on
> s390 arch.
> I will have reports tomorrow.
> 
> Thanks for prompt response!

Perfect, thank you so much!
